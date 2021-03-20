const jwtStrategy = require('passport-jwt').Strategy;
const extractJwt = require('passport-jwt').ExtractJwt;

const user = require('../models/userModel');
const dbConfig = require('../config/dbConfig');

module.exports = (passport) => {
    var data = {}

    data.secretOrKey = dbConfig.secret;
    data.jwtFromRequest = extractJwt.fromAuthHeaderWithScheme('jwt');

    passport.use(new jwtStrategy(data, (payload, func) => {
        user.find({
            id: payload.id
        }), (err, user) => {
            if(err) {
                return func(err, false);
            }
            if(user) {
                return func(null, user);
            } else {
                return func(null, false);
            }
        }
    }))
}