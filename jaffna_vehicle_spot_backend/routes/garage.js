const express = require('express');
const router = express.Router();
const { sendToGarage, returnFromGarage, getGarageRecords } = require('../controllers/garageController');
const { protect, authorize } = require('../middleware/auth');

router.post('/', protect, authorize('ADMIN', 'MANAGER'), sendToGarage);
router.put('/return/:id', protect, authorize('ADMIN', 'MANAGER'), returnFromGarage);
router.get('/', protect, authorize('ADMIN', 'MANAGER'), getGarageRecords);

module.exports = router;
