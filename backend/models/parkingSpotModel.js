const mongoose = require('mongoose');

const Schema = mongoose.Schema;

const locationSchema = new Schema({
    latitude: {
        type: Number,
        require: true
    }, 
    longitude: {
        type: Number,
        require: true
    }
});

const parkingBlockSchema = new Schema({
    macAddress: String,
    serviceUUID: String,
    characteristicUUID: String
});

const parkingSpotSchema = new Schema({
    location: locationSchema,
    parkingBlock: parkingBlockSchema,
    available: Boolean
});

module.exports = mongoose.model('ParkingSpot', parkingSpotSchema);