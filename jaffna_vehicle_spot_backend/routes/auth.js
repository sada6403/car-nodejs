const express = require('express');
const router = express.Router();
const { loginUser, getMe, seedAdmin } = require('../controllers/authController');
const { protect } = require('../middleware/auth');

router.post('/login', loginUser);
router.post('/seed', seedAdmin); // Temporary endpoint to seed an initial admin
router.get('/me', protect, getMe);

module.exports = router;
