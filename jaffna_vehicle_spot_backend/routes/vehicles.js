const express = require('express');
const router = express.Router();
const { getVehicles, addVehicle, updateVehicle, deleteVehicle } = require('../controllers/vehicleController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(protect, getVehicles)
  .post(protect, authorize('ADMIN', 'MANAGER'), addVehicle);

router.route('/:id')
  .put(protect, authorize('ADMIN', 'MANAGER'), updateVehicle)
  .delete(protect, authorize('ADMIN'), deleteVehicle);

module.exports = router;
