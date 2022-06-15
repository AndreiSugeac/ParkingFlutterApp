const jwt = require('jwt-simple');

const ParkingSpot = require('../model/parkingSpot');
const User = require('../model/user');
const Schedule = require('../model/schedule')
const Location = require('../model/location')
const config = require('../config/dbConfig');
const { json } = require('body-parser');
const LocationService = require('../service/locationService')

var services = {

    async addParkingSpot(req, res) {
        if(!req.body.latitude || 
           !req.body.longitude) {

            res.json({
                success: false,
                msg: 'Missing required information about the parking spot'
            });
        }
        else {
            try{
                const newParkingSpot = await ParkingSpot.create({
                    available: req.body.available != null ? req.body.available : true
                });
                
                const location = await LocationService.addLocation(req.body.latitude, req.body.longitude, newParkingSpot.id)
        
                res.json({
                    success: true,
                    msg: 'Your parking spot has been successfully saved!',
                    spot: newParkingSpot
                });
            }catch(err){
                res.json({
                    success: false,
                    msg: 'Your parking spot could not be saved!'
                });
                console.log(err);
            }        
        }
    },

    getSchedulerByParkingSpotId: (req, res) => {
        if(req.params.id) {
            _id = parseInt(req.params.id)
            Schedule.findOne({
                where: { 
                 parkingSpotId: _id
                }
             }).then((schedule, err) => {
                if(err) {
                    res.json({
                        success: false,
                        msg: 'An error occured while getting scheduler by spot id!'
                    });
                    throw err;
                }
                else {
                    if(!schedule) {
                        res.json({
                            success: false,
                            msg: 'This parking spot does not have a schedule!',
                            hasSchedule: false
                        });
                    }
                    else {
                        res.json({
                            success: true,
                            msg: 'Successfully retrieved the schedule for the parking spot with the specified id!',
                            hasSchedule: true,
                            schedule: schedule
                        });
                    }
                }
            });
        }
        else {
            res.json({
                success: false,
                msg: 'The id of the parking spot must not be null!'
            })
        }
    },

    getLocationByParkingSpotId: (req, res) => {
        if(req.params.id) {
            _id = parseInt(req.params.id)
            Location.findOne({
                where: { 
                 parkingSpotId: _id
                }
             }).then((location, err) => {
                if(err) {
                    res.json({
                        success: false,
                        msg: 'An error occured while getting location by spot id!'
                    });
                    throw err;
                }
                else {
                    if(!location) {
                        res.json({
                            success: false,
                            msg: 'This parking spot does not have a location!',
                            hasLocation: false
                        });
                    }
                    else {
                        res.json({
                            success: true,
                            msg: 'Successfully retrieved the location for the parking spot with the specified id!',
                            location: location
                        });
                    }
                }
            });
        }
        else {
            res.json({
                success: false,
                msg: 'The id of the parking spot must not be null!'
            })
        }
    },

    async getAvailableParkingSpots(req, res) {
        docs = await ParkingSpot.findAll({where: {
            available: true
        }});
        if(docs) {
            res.json({
                success: true,
                msg: 'Successfully retrieved all available parking spots.',
                parkingSpots: docs
            });
        }
    },

    getParkingSpotById: (req, res) => {
        // if(req.params.id) {
        //     ParkingSpot.findById({
        //         _id: req.params.id
        //     }, (err, parkingSpot) => {
        //         if(err) {
        //             throw err;
        //         }
        //         else {
        //             if(!parkingSpot) {
        //                 res.status(403).send({
        //                     success: false,
        //                     msg: 'No parking spot was found with this id!'
        //                 });
        //             }
        //             else {
        //                 res.json({
        //                     success: true,
        //                     msg: 'Found parking spot with the specified id!',
        //                     parkingSpot: parkingSpot
        //                 });
        //             }
        //         }
        //     });
        // }
        // else {
        //     res.json({
        //         success: false,
        //         msg: 'The id must not be null!'
        //     });
        // }
        if(req.params.id) {
            ParkingSpot.findOne({
                where: { 
                    id: req.params.id
                }
             }).then((spot, err) => {
                if(err) {
                    res.json({
                        success: false,
                        msg: 'An error occured while getting user by id!'
                    });
                    throw err;
                }
                else {
                    if(!spot) {
                        res.json({
                            success: false,
                            msg: 'The parking spot does not exist!',
                            hasSpot: false
                        });
                    }
                    else {
                        res.json({
                            success: true,
                            msg: 'Successfully retrieved the parking spot!',
                            hasSpot: true,
                            parkingSpot: spot
                        });
                    }
                }
            });
        }
        else {
            res.json({
                success: false,
                msg: 'The id must not be null!'
            })
        }
    },

    getSpotById: async (id) => {
        await ParkingSpot.findOne({
            where: { 
                id: id
            }
         }).then((spot, err) => {
            if(err) {
                return null
            }
            else {
                return spot;
            }
        });
    },

    getParkingSpotByUserId: (req, res) => {
        if(req.params.id) {
            ParkingSpot.findOne({
                where: { 
                 userId: req.params.id
                }
             }).then((spot, err) => {
                if(err) {
                    res.json({
                        success: false,
                        msg: 'An error occured while getting user by id!'
                    });
                    throw err;
                }
                else {
                    if(!spot) {
                        res.json({
                            success: false,
                            msg: 'This user does not have a parking spot!',
                            hasSpot: false
                        });
                    }
                    else {
                        res.json({
                            success: true,
                            msg: 'Successfully retrieved the parking spot for the user with the specified id!',
                            hasSpot: true,
                            parkingSpot: spot
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

    updateParkingSpotAvailability: (req, res) => {
        if(!req.body.parkingSpotId || req.body.available == null) {
            res.json({
                success: false,
                msg: 'Missing required information about the availability'
            });
        } else {
            ParkingSpot.findByIdAndUpdate(
                req.body.parkingSpotId,
                {
                    available: req.body.available
                },
                function (err, result) {
                    if(err) {
                        res.json({
                            success: false,
                            msg: 'Could not change property available of parking spot!'
                        });
                    } else {
                        if(result) {
                            res.json({
                                success: true,
                                msg: 'Property available successfully updated for parking spot!',
                                parkingSpot: result
                            });
                        }
                        else {
                            res.json({
                                success: false,
                                msg: 'Querry returned null!',
                            });
                        }
                    }
                }
            );
        }
    },

    findScheduleByParkingSpotId : async id => {
        _id = parseInt(id)
        return await Schedule.findOne({
            where: { 
             parkingSpotId: _id
            }
         }).then((schedule, err) => {
            if(err) {
                return null;
            } else {
                if(schedule) {
                    return schedule
                }
                else {
                    return null;
                }
            }
        }
        );
    },

    async setSchedule(req, res) {
        if(!req.body.parkingSpotId || !req.body.startDate || !req.body.startTime || !req.body.endTime || !req.body.endDate || !req.body.isActive) {
            res.json({
                success: false,
                msg: 'Missing required information about the schedule'
            });
        } else {
            _id = parseInt(req.body.parkingSpotId)
            sch = await Schedule.findOne({
                where: { 
                parkingSpotId: _id
                }
            }).then((schedule, err) => {
                if(err) {
                    return null;
                } else {
                    if(schedule) {
                        return schedule
                    }
                    else {
                        return null;
                    }
                }
            }
            );
            if(sch) {
                sch.update({
                    startDate: req.body.startDate,
                    startTime: req.body.startTime,
                    endTime: req.body.endTime,
                    endDate: req.body.endDate,
                    isActive: req.body.isActive
                })
            }
            else {
                const schedule = await Schedule.create({
                    startDate: req.body.startDate,
                    startTime: req.body.startTime,
                    endTime: req.body.endTime,
                    endDate: req.body.endDate,
                    isActive: req.body.isActive,
                    parkingSpotId: req.body.parkingSpotId
                })
            }
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