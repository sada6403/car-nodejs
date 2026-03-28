const express = require('express');
const router = express.Router();
const { getBranches, addBranch, updateBranch } = require('../controllers/branchController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(protect, getBranches)
  .post(protect, authorize('ADMIN'), addBranch);

router.route('/:id')
  .put(protect, authorize('ADMIN'), updateBranch);

module.exports = router;
