'use strict';

module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable('invoices', {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER
            },
            invoice_number: {
                type: Sequelize.STRING,
                allowNull: false,
                unique: true,
                comment: 'Unique invoice number'
            },
            user_id: {
                type: Sequelize.INTEGER,
                allowNull: false,
                references: {
                    model: 'users',
                    key: 'id'
                },
                onUpdate: 'CASCADE',
                onDelete: 'CASCADE'
            },
            event_id: {
                type: Sequelize.INTEGER,
                allowNull: false,
                references: {
                    model: 'events',
                    key: 'id'
                },
                onUpdate: 'CASCADE',
                onDelete: 'CASCADE'
            },
            payment_id: {
                type: Sequelize.INTEGER,
                allowNull: true,
                comment: 'NULL for free events'
            },
            registration_id: {
                type: Sequelize.INTEGER,
                allowNull: false,
                references: {
                    model: 'eventregistrations',
                    key: 'id'
                },
                onUpdate: 'CASCADE',
                onDelete: 'CASCADE'
            },
            invoice_type: {
                type: Sequelize.ENUM('free', 'paid'),
                allowNull: false,
                comment: 'Type of invoice - free or paid event'
            },
            amount: {
                type: Sequelize.DECIMAL(15, 2),
                defaultValue: 0.00,
                allowNull: false,
                comment: 'Invoice amount (0 for free events)'
            },
            tax_amount: {
                type: Sequelize.DECIMAL(15, 2),
                defaultValue: 0.00,
                allowNull: false,
                comment: 'Tax amount if applicable'
            },
            total_amount: {
                type: Sequelize.DECIMAL(15, 2),
                defaultValue: 0.00,
                allowNull: false,
                comment: 'Total amount including tax'
            },
            invoice_status: {
                type: Sequelize.ENUM('draft', 'issued', 'paid', 'cancelled'),
                defaultValue: 'issued',
                allowNull: false
            },
            issued_date: {
                type: Sequelize.DATE,
                defaultValue: Sequelize.NOW,
                allowNull: false
            },
            due_date: {
                type: Sequelize.DATE,
                allowNull: true,
                comment: 'Due date for paid invoices'
            },
            paid_date: {
                type: Sequelize.DATE,
                allowNull: true,
                comment: 'Date when invoice was paid'
            },
            notes: {
                type: Sequelize.TEXT,
                allowNull: true,
                comment: 'Additional notes for the invoice'
            },
            createdAt: {
                allowNull: false,
                type: Sequelize.DATE
            },
            updatedAt: {
                allowNull: false,
                type: Sequelize.DATE
            }
        });
    },

    async down(queryInterface, Sequelize) {
        await queryInterface.dropTable('invoices');
    }
};
