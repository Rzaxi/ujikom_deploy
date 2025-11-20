'use strict';

module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.addColumn('eventregistrations', 'payment_id', {
            type: Sequelize.INTEGER,
            allowNull: true,
            comment: 'ID pembayaran untuk event berbayar, NULL untuk event gratis'
        });
    },

    async down(queryInterface, Sequelize) {
        await queryInterface.removeColumn('eventregistrations', 'payment_id');
    }
};
