// Dependency section
const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const passport = require('passport');

const connectDb = require('./config/db');
const routes = require('./routes/routes');

// Connection to Db
connectDb();

// Server side
const app = express();

if(process.env.NODE_ENV === 'development') {
    //  Logger middleware
    app.use(morgan('dev'));
}
app.use(express.urlencoded({extended: false }));
app.use(express.json());
app.use(passport.initialize());
require('./config/passport')(passport);
app.use(cors());

// App is using the routes to direct requests
app.use(routes);

// If running locally it will use port 3000, but if hosting it will use process.env.PORT
const PORT = process.env.PORT || 3000;


app.listen(PORT, console.log('Server is running on port ' + PORT + ', in ' + process.env.NODE_ENV + ' mode.'));