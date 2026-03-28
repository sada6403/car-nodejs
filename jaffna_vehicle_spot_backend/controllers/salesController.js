const { Sales, Vehicle } = require('../models');

// Usually there is a POST /sales/add or similar, but inferred from the prompt
const createSales = async (req, res) => {
  try {
    const { vehicle_id, customer_name, total_amount, branch_id } = req.body;
    
    const vehicle = await Vehicle.findById(vehicle_id);
    if (!vehicle) return res.status(404).json({ message: 'Vehicle not found' });

    const sale = await Sales.create({
      vehicle_id, customer_name, total_amount, branch_id
    });

    vehicle.status = 'Sold';
    await vehicle.save();

    res.status(201).json(sale);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

const getSalesList = async (req, res) => {
  try {
    const sales = await Sales.find().populate('vehicle_id', 'vehicle_name').populate('branch_id', 'branch_name');
    res.json(sales);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = { createSales, getSalesList };
