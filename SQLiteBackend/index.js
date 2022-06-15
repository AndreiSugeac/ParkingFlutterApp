// Dependency section
const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const passport = require('passport');
const sequelize = require('./config/db');

const routes = require('./router/routes');

// associations
const Location = require('./model/location')
const Schedule = require('./model/schedule')
const ParkingSpot = require('./model/parkingSpot')
const User = require('./model/user')

User.hasOne(ParkingSpot);
ParkingSpot.belongsTo(User);

ParkingSpot.hasOne(Location)
Location.belongsTo(ParkingSpot)

ParkingSpot.hasOne(Schedule)
Schedule.belongsTo(ParkingSpot)

// Connection to the Db
sequelize.sync({alter: true}).then(() => console.log('db is ready')).catch((err) => {
    console.log(err)
})

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