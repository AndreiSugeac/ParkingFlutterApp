const bcrypt = require('bcrypt');
const mongoose = require('mongoose');

const Schema = mongoose.Schema;

const userSchema = new Schema({
    firstName: {
        type: String,
        require: true
    },
    lastName: {
        type: String,
        require: true
    },
    email: {
        type: String,
        require: true
    },
    password: {
        type: String,
        require: true
    },
    cars: [{
        type: Schema.Types.Number,
        ref: 'Car'
    }]
});

// This function will hash the password for all new users and for past users that are modifying it
userSchema.pre('save', function(next) {
    var user = this;
    if(this.isModified('password') || this.isNew) {
        bcrypt.genSalt(10, (err, salt) => {
            if(err) {
                return next(err);
            }
            bcrypt.hash(user.password, salt, (err, hash) => {
                if(err) {
                    return next(err);
                }
                user.password = hash;
                next();
            });
        });
    }
    else {
        return next();
    }
});

// userSchema methods
userSchema.methods.comparePass = function(pass, func) {
    bcrypt.compare(pass, this.password, (err, matching) => {
        if(err) {
            return func(err);
        } 
        func(null, matching);
    })
}

module.exports = mongoose.model('User', userSchema);