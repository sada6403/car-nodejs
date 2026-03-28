const mongoose = require('mongoose');

const attendanceSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  login_time: { type: Date },
  logout_time: { type: Date },
  date: { type: Date, required: true },
  login_location: { type: String },
  logout_location: { type: String },
}, { timestamps: true });

module.exports = mongoose.model('Attendance', attendanceSchema);
