const mongoose = require('mongoose');

const commissionSchema = new mongoose.Schema({
  agent_name: { type: String, required: true },
  contact: { type: String },
  sale_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Sales', required: true },
  commission_type: { type: String, enum: ['Fixed', 'Percentage'], default: 'Fixed' },
  amount: { type: Number, required: true },
  date: { type: Date, default: Date.now }
}, { timestamps: true });

module.exports = mongoose.model('Commission', commissionSchema);
