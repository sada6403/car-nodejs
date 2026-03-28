const express = require('express');
const router = express.Router();
const { getCommissions, createCommission } = require('../controllers/commissionController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(protect, authorize('ADMIN', 'MANAGER'), getCommissions)
  .post(protect, authorize('ADMIN', 'MANAGER'), createCommission);

module.exports = router;
