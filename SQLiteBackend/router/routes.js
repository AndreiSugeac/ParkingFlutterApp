const express = require('express');

const userServices = require('../service/userService');
const parkingSpotServices = require('../service/parkingSpotService');
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
Router.put('/update/user/parkingSpot/:idUser/:idParkingSpot', userServices.addParkingSpotForUser);

// @desc Set schedule for parking spot
Router.put('/update/parkingSpot/schedule', parkingSpotServices.setSchedule);

// @desc Update property available of parking spot
Router.put('/update/available/parkingSpot', parkingSpotServices.updateParkingSpotAvailability);


// ParkingSpot routes

// GET REQUESTS
// @desc Route for getting a parking spot by id
Router.get('/parkingSpot/get/:id', parkingSpotServices.getParkingSpotById);

// @desc Route for getting a parking spot by its owner id
Router.get('/parkingSpot/byUser/get/:id', parkingSpotServices.getParkingSpotByUserId);

// @desc Route for getting all available parking spots
Router.get('/parkingSpot/available/get', parkingSpotServices.getAvailableParkingSpots);

Router.get('/scheduler/byParkingSpotId/get/:id', parkingSpotServices.getSchedulerByParkingSpotId);

Router.get('/location/byParkingSpotId/get/:id', parkingSpotServices.getLocationByParkingSpotId);

// POST REQUESTS
// @desc Route for inserting new parking spots
Router.post('/parkingSpot/add', parkingSpotServices.addParkingSpot);

//DELETE REQUESTS
// @desc Route for deleting a parking spot by id
Router.delete('/parkingSpot/delete/:id', parkingSpotServices.deleteParkingSpotById);

module.exports = Router;