const express = require('express');

const userServices = require('../services/userServices');
const carServices = require('../services/carServices');
const parkingSpotServices = require('../services/parkingSpotServices');
const Router = express.Router();

// User routes

//GET REQUESTS
// @desc Dummy test route
Router.get('/', (req, res) => {
    res.send('Hello World');
});

// @Desc Route for checking token of a user
Router.get('/getJwt', userServices.verifyUser);

//POST REQUESTS
// @desc Route for registering new users
Router.post('/register/user', userServices.addNewUser);

// @desc Route for authenticating existing users
Router.post('/authenticate/user', userServices.authUser);

//PUT REQUESTS
// @desc Route for adding a existing parking spot to a user account
Router.put('/update/user/parkingSpot', userServices.addParkingSpotForUser);


// Car routes

//GET REQUESTS
// @desc Route for getting a car by id
Router.get('/cars/get/:id', carServices.getCarById);

//POST REQUESTS
// @desc Route for inserting new cars
Router.post('/cars/add', carServices.addNewCar);


// ParkingSpot routes

// GET REQUESTS
// @desc Route for getting a parking spot by id
Router.get('/parkingSpot/get/:id', parkingSpotServices.getParkingSpotById);

// @desc Route for getting a parking spot by its owner id
Router.get('/parkingSpot/get/byUser/:id', parkingSpotServices.getParkingSpotByUserId)

// POST REQUESTS
// @desc Route for inserting new parking spots
Router.post('/parkingSpot/add', parkingSpotServices.addParkingSpot);

//DELETE REQUESTS
// @desc Route for deleting a parking spot by id
Router.delete('/parkingSpot/delete/:id', parkingSpotServices.deleteParkingSpotById);

module.exports = Router;