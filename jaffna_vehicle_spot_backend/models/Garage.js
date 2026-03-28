const mongoose = require('mongoose');

const garageSchema = new mongoose.Schema({
  vehicle_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Vehicle', required: true },
  garage_name: { type: String, required: true },
  owner_name: { type: String },
  contact_number: { type: String },
  address: { type: String },
  problem_description: { type: String },
  sent_date: { type: Date, default: Date.now },
  driver_name: { type: String },
  total_amount: { type: Number },
  advance_amount: { type: Number },
  status: { type: String, enum: ['In Progress', 'Completed'], default: 'In Progress' }
}, { timestamps: true });

module.exports = mongoose.model('Garage', garageSchema);
