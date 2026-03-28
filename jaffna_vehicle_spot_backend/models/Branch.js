const mongoose = require('mongoose');

const branchSchema = new mongoose.Schema({
  branch_name: { type: String, required: true },
  branch_code: { type: String, required: true, unique: true },
  address: { type: String },
  phone: { type: String },
  manager_name: { type: String },
  status: { type: String, enum: ['Active', 'Inactive'], default: 'Active' },
}, {
  timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' }
});

module.exports = mongoose.model('Branch', branchSchema);
