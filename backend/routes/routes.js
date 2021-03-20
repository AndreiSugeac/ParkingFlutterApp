const express = require('express');

const userServices = require('../services/userServices');
const Router = express.Router();

//GET REQUESTS
// @desc Dummy test route
Router.get('/', (req, res) => {
    res.send('Hello World');
});

// @Desc Route for checking token of a user
Router.get('/getJwt', userServices.getUser);

//POST REQUESTS
// @desc Route for registering new users
Router.post('/register/user', userServices.addNewUser);

// @desc Route for authenticating existing users
Router.post('/authenticate/user', userServices.authUser);

module.exports = Router;