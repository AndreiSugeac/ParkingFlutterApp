const { Model, DataTypes } = require('sequelize');
const sequelize = require('../config/db')
const bcrypt = require('bcrypt');

class User extends Model {
    comparePass = function(pass, func) {
        bcrypt.compare(pass, this.password, (err, matching) => {
            if(err) {
                return func(err);
            } 
            func(null, matching);
        })
    }
}
User.init({
    firstName: {
        type: DataTypes.STRING,
        require: true
    },
    lastName: {
        type: DataTypes.STRING,
        require: true
    },
    email: {
        type: DataTypes.STRING,
        require: true
    },
    password: {
        type: DataTypes.STRING,
        require: true
    },
    },
    {sequelize},
    // {
    //     hooks: {
    //         beforeCreate: (user, options, next) => {
    //             bcrypt.genSalt(10, (err, salt) => {
    //                 if(err) {
    //                     return next(err);
    //                 }
    //                 bcrypt.hash(user.password, salt, (err, hash) => {
    //                     if(err) {
    //                         return err;
    //                     }
    //                     user.password = hash;
    //                     debug('Info: ' + 'password now is: ' + user.password);
    //                     return next(null, options)
    //                 });
    //             });
    //         }
    //     }
    // },
)

User.beforeCreate(function(user, options) {
    return new Promise ((resolve, reject) => {
        bcrypt.genSalt(10, (err, salt) => {
            if(err) {
                return reject(err);
            }
            bcrypt.hash(user.password, salt, (err, hash) => {
                if(err) {
                    return reject(err);
                }
                user.password = hash;
                console.log('Info: ' + 'password now is: ' + user.password);
                return resolve(user, options)
            });
        });
    }); 
})

module.exports = User;