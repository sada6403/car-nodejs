const express = require('express');
const router = express.Router();
const { clockIn, clockOut, getReports } = require('../controllers/attendanceController');
const { protect, authorize } = require('../middleware/auth');

router.post('/clock-in', protect, clockIn);
router.put('/clock-out', protect, clockOut);
router.get('/reports', protect, authorize('ADMIN', 'MANAGER'), getReports);

module.exports = router;
