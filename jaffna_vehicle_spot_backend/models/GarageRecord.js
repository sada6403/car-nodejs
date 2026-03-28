const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');
const Vehicle = require('./Vehicle');

const GarageRecord = sequelize.define('GarageRecord', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  garageName: DataTypes.STRING,
  ownerName: DataTypes.STRING,
  contactNumber: DataTypes.STRING,
  reason: DataTypes.STRING,
  totalAmount: DataTypes.FLOAT,
  advanceAmount: DataTypes.FLOAT,
  status: {
    type: DataTypes.ENUM('ACTIVE', 'RETURNED'),
    defaultValue: 'ACTIVE',
  },
  returnedAt: DataTypes.DATE,
});

GarageRecord.belongsTo(Vehicle, { foreignKey: 'vehicleId', as: 'vehicle' });
Vehicle.hasMany(GarageRecord, { foreignKey: 'vehicleId' });

module.exports = GarageRecord;
