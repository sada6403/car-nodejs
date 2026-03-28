const mongoose = require('mongoose');

const salesSchema = new mongoose.Schema({
  vehicle_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Vehicle', required: true },
  customer_name: { type: String, required: true },
  total_amount: { type: Number, required: true },
  date: { type: Date, default: Date.now },
  branch_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Branch', required: true }
}, { timestamps: true });

module.exports = mongoose.model('Sales', salesSchema);
