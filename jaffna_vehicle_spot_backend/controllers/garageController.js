const { Garage, Vehicle } = require('../models');

// POST /garage/add
const sendToGarage = async (req, res) => {
  try {
    const { vehicle_id, garage_name, owner_name, contact_number, address, problem_description, driver_name, total_amount, advance_amount } = req.body;
    
    const vehicle = await Vehicle.findById(vehicle_id);
    if (!vehicle) return res.status(404).json({ message: 'Vehicle not found' });

    const record = await Garage.create({
      vehicle_id, garage_name, owner_name, contact_number, address, problem_description, driver_name, total_amount, advance_amount
    });

    vehicle.status = 'In Garage';
    await vehicle.save();

    res.status(201).json(record);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// GET /garage/list
const getGarageRecords = async (req, res) => {
  try {
    const records = await Garage.find().populate('vehicle_id', 'vehicle_name vehicle_number');
    res.json(records);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = { sendToGarage, getGarageRecords };
