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

const scheduleSchema = new Schema({
    startDate: String,
    startTime: String,
    endTime: String,
    endDate: String,
    isActive: Boolean
});

const parkingSpotSchema = new Schema({
    location: locationSchema,
    parkingBlock: parkingBlockSchema,
    schedule: scheduleSchema,
    available: Boolean
});

module.exports = mongoose.model('ParkingSpot', parkingSpotSchema);