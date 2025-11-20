'use strict';

module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable('payments', {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER
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
            order_id: {
                type: Sequelize.STRING,
                allowNull: false,
                unique: true,
                comment: 'Unique order ID for Midtrans'
            },
            transaction_id: {
                type: Sequelize.STRING,
                allowNull: true,
                comment: 'Midtrans transaction ID'
            },
            amount: {
                type: Sequelize.DECIMAL(15, 2),
                allowNull: false,
                comment: 'Payment amount'
            },
            payment_method: {
                type: Sequelize.STRING,
                allowNull: true,
                comment: 'Payment method used (e.g., credit_card, bank_transfer)'
            },
            payment_status: {
                type: Sequelize.ENUM('pending', 'paid', 'failed', 'cancelled', 'expired'),
                defaultValue: 'pending',
                allowNull: false
            },
            midtrans_response: {
                type: Sequelize.TEXT,
                allowNull: true,
                comment: 'Full Midtrans response JSON'
            },
            snap_token: {
                type: Sequelize.TEXT,
                allowNull: true,
                comment: 'Midtrans Snap token for frontend'
            },
            paid_at: {
                type: Sequelize.DATE,
                allowNull: true,
                comment: 'Timestamp when payment was completed'
            },
            expired_at: {
                type: Sequelize.DATE,
                allowNull: true,
                comment: 'Payment expiration time'
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
        await queryInterface.dropTable('payments');
    }
};
