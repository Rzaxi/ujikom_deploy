'use strict';
const {
    Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class Invoice extends Model {
        static associate(models) {
            Invoice.belongsTo(models.User, {
                foreignKey: 'user_id',
                as: 'user'
            });
            Invoice.belongsTo(models.Event, {
                foreignKey: 'event_id',
                as: 'event'
            });
            Invoice.belongsTo(models.Payment, {
                foreignKey: 'payment_id',
                as: 'payment'
            });
            Invoice.belongsTo(models.EventRegistration, {
                foreignKey: 'registration_id',
                as: 'registration'
            });
        }
    }
    Invoice.init({
        id: {
            allowNull: false,
            autoIncrement: true,
            primaryKey: true,
            type: DataTypes.INTEGER
        },
        invoice_number: {
            type: DataTypes.STRING,
            allowNull: false,
            unique: true,
            comment: 'Unique invoice number'
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
        payment_id: {
            type: DataTypes.INTEGER,
            allowNull: true,
            references: {
                model: 'payments',
                key: 'id'
            },
            comment: 'NULL for free events'
        },
        registration_id: {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: 'event_registrations',
                key: 'id'
            }
        },
        invoice_type: {
            type: DataTypes.ENUM('free', 'paid'),
            allowNull: false,
            comment: 'Type of invoice - free or paid event'
        },
        amount: {
            type: DataTypes.DECIMAL(15, 2),
            defaultValue: 0.00,
            allowNull: false,
            comment: 'Invoice amount (0 for free events)'
        },
        tax_amount: {
            type: DataTypes.DECIMAL(15, 2),
            defaultValue: 0.00,
            allowNull: false,
            comment: 'Tax amount if applicable'
        },
        total_amount: {
            type: DataTypes.DECIMAL(15, 2),
            defaultValue: 0.00,
            allowNull: false,
            comment: 'Total amount including tax'
        },
        invoice_status: {
            type: DataTypes.ENUM('draft', 'issued', 'paid', 'cancelled'),
            defaultValue: 'issued',
            allowNull: false
        },
        issued_date: {
            type: DataTypes.DATE,
            defaultValue: DataTypes.NOW,
            allowNull: false
        },
        due_date: {
            type: DataTypes.DATE,
            allowNull: true,
            comment: 'Due date for paid invoices'
        },
        paid_date: {
            type: DataTypes.DATE,
            allowNull: true,
            comment: 'Date when invoice was paid'
        },
        notes: {
            type: DataTypes.TEXT,
            allowNull: true,
            comment: 'Additional notes for the invoice'
        }
    }, {
        sequelize,
        modelName: 'Invoice',
        tableName: 'invoices'
    });
    return Invoice;
};
