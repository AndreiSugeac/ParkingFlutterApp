const express = require('express');

const userServices = require('../services/userServices');
const carServices = require('../services/carServices');
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


// Car routes

//GET REQUESTS
// @desc Route for getting a car by id
Router.get('/cars/get/:id', carServices.getCarById)

//POST REQUESTS
// @desc Route for inserting new cars
Router.post('/cars/add', carServices.addNewCar);

module.exports = Router;