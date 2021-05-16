const jwt = require('jwt-simple');

const User = require('../models/userModel');
const config = require('../config/dbConfig');

var services = {

    verifyUser: (req, res) => {
        if(req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
            const tkn = req.headers.authorization.split(' ')[1];
            const decoded = jwt.decode(tkn, config.secret);
            return res.json({
                success: true,
                msg: 'Welcome ' + decoded.name
            });
        }
        else {
            return res.json({
                success: false,
                msg: 'No headers were found!'
            })
        }
    },

    // Creating a new User entity in the DB
    addNewUser: (req, res) => {
        // Checking to see if the all the required fields have been entered
        if((!req.body.firstName) || (!req.body.lastName) || (!req.body.email) || (!req.body.password) || (!req.body.cars)) {
            res.json({
                success: false,
                msg: 'All mandatory fields must be completed!'
            });
        }
        else {
            // if(User.findOne({ email: req.body.email}) || User.findOne({ firstName: req.body.firstName, lastName: req.body.lastName})) {
            //     res.json({
            //         success: false,
            //         msg: 'There is already one user with this cridentials!'
            //     });
            // } else {
                var newUser = User({
                    firstName: req.body.firstName,
                    lastName: req.body.lastName,
                    email: req.body.email,
                    cars: req.body.cars,
                    password: req.body.password
                });

                newUser.save((err, newUser) => {
                    if(err) {
                        res.json({
                            success: false,
                            msg: 'The new user could not be saved!'
                        });
                        console.log(err);
                    }
                    else {
                        res.json({
                            success: true,
                            msg: 'New user has been successfully saved!'
                        });
                    }
                });
            
        }
    },

    // Authenticating a user
    authUser: (req, res) => {
        // Checking to see if all the required fields have been entered
        if((!req.body.email) || (!req.body.password)) {
            res.json({
                success: false,
                msg: 'All mandatory fields must be completed!' 
            });
        } else {
            User.findOne({
                email: req.body.email
            }, (err, user) => {
                if(err) {
                    throw err;
                } else {
                    if(!user) {
                        res.status(403).send({
                            success: false,
                            msg: 'Authentication failed because user could not be found!'
                        });
                    } else {
                        user.comparePass(req.body.password, (err, matching) => {
                            if(matching && !err) {
                                const tkn = jwt.encode(user, config.secret);
                                res.json({
                                    success: true,
                                    msg: 'Authentication successful!',
                                    token: tkn
                                });
                            } else {
                                return res.status(403).send({
                                    success: false,
                                    msg: 'Authentication failed because a wrong password was inserted!'
                                });
                            }
                        });
                    }
                }
            });
        }
    },

    addParkingSpotForUser: async (req, res) => {
        if(req.body.idUser && req.body.idParkingSpot) {
            const filter = { _id: req.body.idUser };
            const update = { parkingSpot: req.body.idParkingSpot};
            
            await User.findOneAndUpdate(filter, update, callback= (err) => {
                if(err) {
                    res.json({
                        success: false,
                        msg: 'An error occured while updating your parking spot!'
                    });
                }
                else {
                    res.json({
                        success: true,
                        msg: 'Parking spot was added to your user account!'
                    });
                }
            });
        }
        else {
            res.json({
                success: false,
                msg: 'The ids must not be null!'
            });
        }
    }

    
}

module.exports = services;