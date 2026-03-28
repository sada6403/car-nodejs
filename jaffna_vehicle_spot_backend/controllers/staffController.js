const { User } = require('../models');
const bcrypt = require('bcryptjs');

// GET /api/staff
const getStaff = async (req, res) => {
  try {
    const filters = {};
    if (req.query.branchId) filters.branchId = req.query.branchId;
    if (req.query.role) filters.role = req.query.role;

    const staff = await User.findAll({
      where: filters,
      attributes: { exclude: ['passwordHash'] },
    });
    res.json(staff);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// POST /api/staff
const addStaff = async (req, res) => {
  try {
    const { username, password, role, fullName, email, mobileNo, nicNo, branchId } = req.body;
    
    const userExists = await User.findOne({ where: { username } });
    if (userExists) return res.status(400).json({ message: 'User already exists' });

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    const user = await User.create({
      username,
      passwordHash,
      role,
      fullName,
      email,
      mobileNo,
      nicNo,
      branchId
    });

    res.status(201).json({
      id: user.id,
      username: user.username,
      role: user.role,
      fullName: user.fullName,
    });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// PUT /api/staff/:id
const updateStaff = async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) return res.status(404).json({ message: 'User not found' });
    
    const { password, ...updateData } = req.body;
    
    if (password) {
      const salt = await bcrypt.genSalt(10);
      updateData.passwordHash = await bcrypt.hash(password, salt);
    }

    await user.update(updateData);
    res.json({ id: user.id, username: user.username, role: user.role, fullName: user.fullName });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

module.exports = { getStaff, addStaff, updateStaff };
