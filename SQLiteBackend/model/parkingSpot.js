const { Model, DataTypes } = require('sequelize');
const sequelize = require('../config/db')

class ParkingSpot extends Model {
}
ParkingSpot.init({
    available: {
        type: DataTypes.BOOLEAN
    },
    },
    {
        sequelize,
        modelName: 'parkingSpot'
    }
)

module.exports = ParkingSpot;