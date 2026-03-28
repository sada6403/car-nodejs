const { Invoice, Vehicle, sequelize } = require('../models');

// GET /api/invoices
const getInvoices = async (req, res) => {
  try {
    const invoices = await Invoice.findAll({ include: ['vehicle', 'salesPerson'] });
    res.json(invoices);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// POST /api/invoices
const createInvoice = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { vehicleId, customerName, customerNic, customerContact, customerAddress, amount, leaseAmount } = req.body;
    
    const vehicle = await Vehicle.findByPk(vehicleId, { transaction: t });
    if (!vehicle) throw new Error('Vehicle not found');
    if (vehicle.status !== 'AVAILABLE') throw new Error('Vehicle is not available for sale');

    const invoice = await Invoice.create({
      vehicleId,
      customerName,
      customerNic,
      customerContact,
      customerAddress,
      amount,
      leaseAmount,
      salesPersonId: req.user.id
    }, { transaction: t });

    await vehicle.update({ status: 'SOLD' }, { transaction: t });

    await t.commit();
    res.status(201).json(invoice);
  } catch (error) {
    await t.rollback();
    res.status(400).json({ message: error.message });
  }
};

module.exports = { getInvoices, createInvoice };
