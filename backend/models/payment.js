'use strict';
const {
    Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class Payment extends Model {
        static associate(models) {
            Payment.belongsTo(models.User, {
                foreignKey: 'user_id',
                as: 'user'
            });
            Payment.belongsTo(models.Event, {
                foreignKey: 'event_id',
                as: 'event'
            });
            Payment.hasOne(models.EventRegistration, {
                foreignKey: 'payment_id',
                as: 'registration'
            });
        }
    }
    Payment.init({
        id: {
            allowNull: false,
            autoIncrement: true,
            primaryKey: true,
            type: DataTypes.INTEGER
        },
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
        order_id: {
            type: DataTypes.STRING,
            allowNull: false,
            unique: true,
            comment: 'Unique order ID for Xendit'
        },
        transaction_id: {
            type: DataTypes.STRING,
            allowNull: true,
            comment: 'Xendit transaction ID'
        },
        amount: {
            type: DataTypes.DECIMAL(15, 2),
            allowNull: false,
            comment: 'Payment amount'
        },
        payment_method: {
            type: DataTypes.STRING,
            allowNull: true,
            comment: 'Payment method used (e.g., credit_card, bank_transfer)'
        },
        payment_status: {
            type: DataTypes.ENUM('pending', 'paid', 'failed', 'cancelled', 'expired'),
            defaultValue: 'pending',
            allowNull: false
        },
        xendit_invoice_id: {
            type: DataTypes.STRING,
            allowNull: true,
            comment: 'Xendit Invoice ID'
        },
        xendit_response: {
            type: DataTypes.TEXT,
            allowNull: true,
            comment: 'Full Xendit response JSON'
        },
        paid_at: {
            type: DataTypes.DATE,
            allowNull: true,
            comment: 'Timestamp when payment was completed'
        },
        expired_at: {
            type: DataTypes.DATE,
            allowNull: true,
            comment: 'Payment expiration time'
        }
    }, {
        sequelize,
        modelName: 'Payment',
        tableName: 'payments'
    });
    return Payment;
};
