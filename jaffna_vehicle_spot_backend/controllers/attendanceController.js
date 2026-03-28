const { Attendance } = require('../models');

// POST /attendance/login
const clockIn = async (req, res) => {
  try {
    const { login_location } = req.body;
    const todayStart = new Date();
    todayStart.setHours(0, 0, 0, 0);

    const existing = await Attendance.findOne({
      user_id: req.user._id,
      date: { $gte: todayStart }
    });

    if (existing) {
      return res.status(400).json({ message: 'Already logged in today' });
    }

    const attendance = await Attendance.create({
      user_id: req.user._id,
      date: new Date(),
      login_time: new Date(),
      login_location
    });

    res.status(201).json(attendance);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// POST /attendance/logout
const clockOut = async (req, res) => {
  try {
    const { logout_location } = req.body;
    const todayStart = new Date();
    todayStart.setHours(0, 0, 0, 0);

    const attendance = await Attendance.findOne({
      user_id: req.user._id,
      date: { $gte: todayStart }
    });

    if (!attendance) return res.status(404).json({ message: 'No login found for today' });

    attendance.logout_time = new Date();
    if(logout_location) attendance.logout_location = logout_location;
    await attendance.save();

    res.json(attendance);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// GET /attendance/report
const getReports = async (req, res) => {
  try {
    const reports = await Attendance.find().populate('user_id', 'name role');
    res.json(reports);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = { clockIn, clockOut, getReports };
