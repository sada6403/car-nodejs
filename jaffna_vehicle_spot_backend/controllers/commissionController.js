const { Commission, Sales } = require('../models');

// GET /commission/report
const getCommissions = async (req, res) => {
  try {
    const commissions = await Commission.find().populate('sale_id');
    res.json(commissions);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// POST /commission/add
const addCommission = async (req, res) => {
  try {
    const { agent_name, contact, sale_id, commission_type, amount } = req.body;
    
    const sale = await Sales.findById(sale_id);
    if (!sale) return res.status(404).json({ message: 'Sale not found' });

    const commission = await Commission.create({
      agent_name,
      contact,
      sale_id,
      commission_type,
      amount
    });

    res.status(201).json(commission);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

module.exports = { getCommissions, addCommission };
