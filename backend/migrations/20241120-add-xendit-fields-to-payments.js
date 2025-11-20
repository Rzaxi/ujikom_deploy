'use strict';

module.exports = {
    up: async (queryInterface, Sequelize) => {
        // Add Xendit-specific fields to payments table
        await queryInterface.addColumn('payments', 'xendit_invoice_id', {
            type: Sequelize.STRING,
            allowNull: true,
            after: 'order_id'
        });

        await queryInterface.addColumn('payments', 'xendit_response', {
            type: Sequelize.TEXT('long'),
            allowNull: true,
            after: 'xendit_invoice_id'
        });

        // Remove Midtrans-specific fields if they exist
        try {
            await queryInterface.removeColumn('payments', 'snap_token');
        } catch (error) {
            console.log('snap_token column does not exist, skipping removal');
        }

        try {
            await queryInterface.removeColumn('payments', 'midtrans_response');
        } catch (error) {
            console.log('midtrans_response column does not exist, skipping removal');
        }
    },

    down: async (queryInterface, Sequelize) => {
        // Remove Xendit fields
        await queryInterface.removeColumn('payments', 'xendit_invoice_id');
        await queryInterface.removeColumn('payments', 'xendit_response');

        // Add back Midtrans fields
        await queryInterface.addColumn('payments', 'snap_token', {
            type: Sequelize.STRING,
            allowNull: true
        });

        await queryInterface.addColumn('payments', 'midtrans_response', {
            type: Sequelize.TEXT('long'),
            allowNull: true
        });
    }
};
