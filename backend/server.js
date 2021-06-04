// Dependency section
const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const passport = require('passport');

const connectDb = require('./config/db');
const routes = require('./routes/routes');

// Connection to the Db
connectDb();

// Server side
const server = express();

// Adding the middleware 
if(process.env.NODE_ENV === 'development') {
    //  Logger middleware for better handling of request responses
    server.use(morgan('dev'));
}
server.use(express.urlencoded({extended: false }));
server.use(express.json());
server.use(passport.initialize());
require('./config/passport')(passport);
server.use(cors());

// server is using the routes to direct requests from clients
server.use(routes);

// If running locally it will use port 3000, but if hosting it will use process.env.PORT that is set in the enviroment variables
const PORT = process.env.PORT || 3000;


server.listen(PORT, console.log('Server is running on port ' + PORT + ', in ' + process.env.NODE_ENV + ' mode.'));