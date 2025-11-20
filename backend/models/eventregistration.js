'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class EventRegistration extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      EventRegistration.belongsTo(models.User, {
        foreignKey: 'user_id',
        as: 'User'
      });
      EventRegistration.belongsTo(models.Event, {
        foreignKey: 'event_id',
        as: 'Event'
      });
      // Optional association - only if TicketCategory model exists
      if (models.TicketCategory) {
        EventRegistration.belongsTo(models.TicketCategory, {
          foreignKey: 'ticket_category_id',
          as: 'TicketCategory'
        });
      }
      // Payment association
      EventRegistration.belongsTo(models.Payment, {
        foreignKey: 'payment_id',
        as: 'Payment'
      });
    }
  }
  EventRegistration.init({
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'Users',
        key: 'id'
      }
    },
    event_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'Events',
        key: 'id'
      }
    },
    ticket_category_id: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'ticket_categories',
        key: 'id'
      },
      comment: 'ID kategori tiket yang dipilih saat registrasi'
    },
    payment_id: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'payments',
        key: 'id'
      },
      comment: 'ID pembayaran untuk event berbayar, NULL untuk event gratis'
    },
    sertifikat_url: {
      type: DataTypes.STRING,
      allowNull: true
    },
    status: {
      type: DataTypes.ENUM('pending', 'confirmed', 'cancelled', 'attended'),
      defaultValue: 'confirmed',
      allowNull: false
    },
    attendance_token: {
      type: DataTypes.STRING(10),
      allowNull: true,
      comment: '10-digit attendance token sent via email during registration'
    },
    attended_at: {
      type: DataTypes.DATE,
      allowNull: true,
      comment: 'Timestamp when participant attended the event'
    }
  }, {
    sequelize,
    modelName: 'EventRegistration',
    tableName: 'eventregistrations'
  });
  return EventRegistration;
};