const jwt = require('jwt-simple');

const ParkingSpot = require('../model/parkingSpot');
const Location = require('../model/location');
const config = require('../config/dbConfig');
const { json } = require('body-parser');

var services = {

    async addLocation(latitude, longitude, parkingSpotId) {
        try{
            const newLocation = await Location.create({
                latitude: latitude,
                longitude: longitude,
                parkingSpotId: parkingSpotId
            });
    
            return newLocation
        }catch(err){
            console.log(err);
            return null
        }        
    }
}

module.exports = services;