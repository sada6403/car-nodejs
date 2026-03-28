const mongoose = require('mongoose');

const vehicleSchema = new mongoose.Schema({
  vehicle_name: { type: String, required: true },
  vehicle_number: { type: String, required: true, unique: true },
  model: { type: String, required: true },
  status: { type: String, enum: ['Available', 'Sold', 'In Garage'], default: 'Available' },
  branch_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Branch', required: true },
}, {
  timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' }
});

module.exports = mongoose.model('Vehicle', vehicleSchema);
