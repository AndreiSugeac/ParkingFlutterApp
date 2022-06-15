const { Model, DataTypes } = require('sequelize');
const sequelize = require('../config/db')

class Schedule extends Model {}
Schedule.init({
    startDate: {
        type: DataTypes.STRING
    }, 
    startTime: {
        type: DataTypes.STRING
    },
    endDate: {
        type: DataTypes.STRING
    }, 
    endTime: {
        type: DataTypes.STRING
    },
    isActive: {
        type: DataTypes.BOOLEAN
    },
    },
    {
        sequelize,
        modelName: 'schedule'
    }
)

module.exports = Schedule;