const express = require('express');
const router = express.Router();
const { getInvoices, createInvoice } = require('../controllers/invoiceController');
const { protect } = require('../middleware/auth');

router.route('/')
  .get(protect, getInvoices)
  .post(protect, createInvoice);

module.exports = router;
