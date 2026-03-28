const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');
const Vehicle = require('./Vehicle');
const User = require('./User');

const Invoice = sequelize.define('Invoice', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  customerName: DataTypes.STRING,
  customerNic: DataTypes.STRING,
  customerContact: DataTypes.STRING,
  customerAddress: DataTypes.STRING,
  
  amount: DataTypes.STRING,
  leaseAmount: DataTypes.STRING,
  status: {
    type: DataTypes.ENUM('PAID', 'PENDING', 'OVERDUE'),
    defaultValue: 'PAID',
  },
});

Invoice.belongsTo(Vehicle, { foreignKey: 'vehicleId', as: 'vehicle' });
Vehicle.hasOne(Invoice, { foreignKey: 'vehicleId' });

Invoice.belongsTo(User, { foreignKey: 'salesPersonId', as: 'salesPerson' });
User.hasMany(Invoice, { foreignKey: 'salesPersonId' });

module.exports = Invoice;
