const jwt = require('jwt-simple');

const config = require('../config/dbConfig');
const User = require('../model/user');
const ParkingSpot = require('../model/parkingSpot');
const parkingSpotService = require('../service/parkingSpotService')

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
    async addNewUser(req, res) {
        // Checking to see if the all the required fields have been entered
        if((!req.body.firstName) || (!req.body.lastName) || (!req.body.email) || (!req.body.password)) {
            res.json({
                success: false,
                msg: 'All mandatory fields must be completed!'
            });
        }
        else {

            try{
                const user = await User.create({
                    firstName: req.body.firstName,
                    lastName: req.body.lastName,
                    email: req.body.email,
                    password: req.body.password
                });
        
                res.json({
                    success: true,
                    msg: 'New user has been successfully saved!'
                });
            }catch(err){
                res.json({
                    success: false,
                    msg: 'The new user could not be saved!'
                });
                console.log(err);
            }        
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
               where: { 
                email: req.body.email
               }
            }).then((user, err) => {
                if(err) {
                    throw err;
                } else {
                    if(!user) {
                        res.status(403).send({
                            success: false,
                            msg: 'Authentication failed because user could not be found!'
                        });
                    } else {
                        user.comparePass(req.body.password, (err, match) => {
                            if(match && !err) {
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
        if(req.params.idUser && req.params.idParkingSpot) {
            try {
                _userId = parseInt(req.params.idUser)
                _parkingSpotId = parseInt(req.params.idParkingSpot)

                const parking = await ParkingSpot.update({UserId: _userId},{where: {id: _parkingSpotId}});
                return res.json({
                    success: true,
                    msg: 'Parking spot was added to your user account!'
                });
            } catch (err) {
                return res.json({
                    success: false,
                    msg: 'An error occured while updating your parking spot!'
                });
              }
           
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