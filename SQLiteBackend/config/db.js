const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('parkingappdb', 'user', 'pass', {
    dialect: 'sqlite',
    host: './parkingappdb.db'
})

module.exports = sequelize;