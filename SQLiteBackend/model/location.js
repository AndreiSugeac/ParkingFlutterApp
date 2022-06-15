const { Model, DataTypes } = require('sequelize');
const sequelize = require('../config/db')

class Location extends Model {}
Location.init({
    latitude: {
        type: DataTypes.NUMBER,
        require: true
    }, 
    longitude: {
        type: DataTypes.NUMBER,
        require: true
    },
    },
    {
        sequelize,
        modelName: 'location'
    }
)

module.exports = Location;