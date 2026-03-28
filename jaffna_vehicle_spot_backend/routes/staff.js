const express = require('express');
const router = express.Router();
const { getStaff, addStaff, updateStaff } = require('../controllers/staffController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(protect, authorize('ADMIN', 'MANAGER'), getStaff)
  .post(protect, authorize('ADMIN'), addStaff);

router.route('/:id')
  .put(protect, authorize('ADMIN', 'MANAGER'), updateStaff);

module.exports = router;
