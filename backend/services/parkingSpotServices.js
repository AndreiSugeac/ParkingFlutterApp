const jwt = require('jwt-simple');

const ParkingSpot = require('../models/parkingSpotModel');
const User = require('../models/userModel');
const config = require('../config/dbConfig');
const { json } = require('body-parser');

var services = {

    addParkingSpot: (req, res) => {
        if(!req.body.latitude || 
           !req.body.longitude ||
           !req.body.macAddress ||
           !req.body.serviceUUID ||
           !req.body.characteristicUUID) {

            res.json({
                success: false,
                msg: 'Missing required information about the parking spot'
            });
        }
        else {
            var newParkingSpot = ParkingSpot({
                location: {
                    latitude: parseFloat(req.body.latitude),
                    longitude: parseFloat(req.body.longitude)
                },
                parkingBlock: {
                    macAddress: req.body.macAddress,
                    serviceUUID: req.body.serviceUUID,
                    characteristicUUID: req.body.characteristicUUID
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
                        spot: newParking
                    });
                }
            });
        }
    },

    getAvailableParkingSpots: (req, res) => {
        ParkingSpot.find({'available': true}, (err, docs) => {
            if(err) {
                res.json({
                    success: false,
                    msg: 'An error occurred while trying to get all available parking spots!'
                });
                throw err;
            }
            else {
                res.json({
                    success: true,
                    msg: 'Successfully retrieved all available parking spots.',
                    parkingSpots: docs
                })
            }
        });
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