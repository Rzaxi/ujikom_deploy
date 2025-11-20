'use strict';

const fs = require('fs');
const path = require('path');
const Sequelize = require('sequelize');
const process = require('process');
const basename = path.basename(__filename);
const db = {};

// Use environment variables for database configuration
const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT || 3306,
    dialect: 'mysql',
    logging: false,
    define: {
      charset: 'utf8mb4',
      collate: 'utf8mb4_general_ci'
    }
  }
);

fs
  .readdirSync(__dirname)
  .filter(file => {
    return (
      file.indexOf('.') !== 0 &&
      file !== basename &&
      file.slice(-3) === '.js' &&
      file.indexOf('.test.js') === -1
    );
  })
  .forEach(file => {
    const model = require(path.join(__dirname, file))(sequelize, Sequelize.DataTypes);
    db[model.name] = model;
  });

Object.keys(db).forEach(modelName => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

db.sequelize = sequelize;
db.Sequelize = Sequelize;

// Auto-sync database tables in production
sequelize.query('SET FOREIGN_KEY_CHECKS = 0;')
  .then(() => {
    return sequelize.sync({ force: false, alter: true });
  })
  .then(() => {
    return sequelize.query('SET FOREIGN_KEY_CHECKS = 1;');
  })
  .then(() => {
    console.log('Database tables synced successfully!');
  })
  .catch(err => {
    console.error('Database sync error:', err);
    // Re-enable foreign key checks even if sync fails
    sequelize.query('SET FOREIGN_KEY_CHECKS = 1;');
  });

module.exports = db;
