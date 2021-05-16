const jwt = require('jwt-simple');

const ParkingSpot = require('../models/parkingSpotModel');
const User = require('../models/userModel');
const config = require('../config/dbConfig');

var services = {

    addParkingSpot: (req, res) => {
        if(!req.body.location.latitude || 
           !req.body.location.longitude ||
           !req.body.parkingBlock.macAddress ||
           !req.body.parkingBlock.serviceUUID ||
           !req.body.parkingBlock.characteristicUUID) {

            res.json({
                success: false,
                msg: 'Missing required information about the parking spot'
            });
        }
        else {
            var newParkingSpot = ParkingSpot({
                location: {
                    latitude: req.body.location.latitude,
                    longitude: req.body.location.longitude
                },
                parkingBlock: {
                    macAddress: req.body.parkingBlock.macAddress,
                    serviceUUID: req.body.parkingBlock.serviceUUID,
                    characteristicUUID: req.body.parkingBlock.characteristicUUID
                },
                available: req.body.available != null ? req.body.available : true 
            });

            newParkingSpot.save((err, newParking) => {
                if(err) {
                    res.json({
                        success: false,
                        msg: 'Your parking spot could not be saved!'
                    });
                }
                else {
                    res.json({
                        success: true,
                        msg: 'Your parking spot has been successfully saved!',
                        id: newParking._id
                    });
                }
            });
        }
    },

    getParkingSpotById: (req, res) => {
        if(req.params.id) {
            ParkingSpot.findById({
                _id: req.params.id
            }, (err, parkingSpot) => {
                if(err) {
                    throw err;
                }
                else {
                    if(!parkingSpot) {
                        res.status(403).send({
                            success: false,
                            msg: 'No parking spot was found with this id!'
                        });
                    }
                    else {
                        res.json({
                            success: true,
                            msg: 'Found parking spot with the specified id!',
                            parkingSpot: parkingSpot
                        });
                    }
                }
            });
        }
        else {
            res.json({
                success: false,
                msg: 'The id must not be null!'
            });
        }
    },

    getParkingSpotByUserId: (req, res) => {
        if(req.params.id) {
            User.findById({
                _id: req.params.id
            }, (err, user) => {
                if(err) {
                    res.json({
                        success: false,
                        msg: 'An error occured while getting user by id!'
                    });
                    throw err;
                }
                else {
                    if(!user.parkingSpot) {
                        res.json({
                            success: false,
                            msg: 'This user does not have a parking spot!',
                            hasSpot: false
                        });
                    }
                    else {
                        ParkingSpot.findById({
                            _id: user.parkingSpot
                        }, (err, parkingSpot) => {
                            if(err) {
                                res.json({
                                    success: false,
                                    msg: 'An error ocurred while getting the parking spot by id!',
                                    hasSpot: true
                                });
                                throw err;
                            }
                            else {
                                res.json({
                                    success: true,
                                    msg: 'Successfully retrieved the parking spot for the user with the specified id!',
                                    hasSpot: true,
                                    parkingSpot: parkingSpot
                                });
                            }
                        }); 
                    }
                }
            });
        }
        else {
            res.json({
                success: false,
                msg: 'The id of the user must not be null!'
            })
        }
    },

    deleteParkingSpotById: (req, res) => {
        if(req.params.id) {
            ParkingSpot.deleteOne({
                _id: req.params.id
            }, (err) => {
                if(err) {
                    res.json({
                        success: false,
                        msg: 'An error occured while trying to delete the parking spot',
                    });
                    throw err;
                }
                else {
                    res.json({
                        success: true,
                        msg: 'Successfully deleted parking spot by id!',
                    });
                }
            });
        }
        else {
            res.json({
                success: false,
                msg: 'The id must not be null!'
            });
        }
    }
}

module.exports = services;