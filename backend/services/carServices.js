const config = require('../config/dbConfig');

const Car = require('../models/carModel');

var services = {
    
    getCarById: (req, res) => {
        if(req.params.id) {
            Car.findById({
                _id: req.params.id
            }, (err, car) => {
                if(err) {
                    throw err;
                }
                else {
                    if(!car) {
                        res.status(403).send({
                            success: false,
                            msg: 'There isn\'t any car with this id!'
                        });
                    } 
                    else {
                        res.json({
                            success: true,
                            msg: 'Found car with the specified id!',
                            car: car
                        });
                    }
                }
            });
        }
        else {
            res.json({
                success: false,
                msg: 'The id must not be null!'
            });
        }
    },

    addNewCar: (req, res) => {
        if((!req.body.brand) || (!req.body.model) || (!req.body.licensePlate)) {
            res.json({
                success: false,
                msg: 'All mandatory fields must be completed!'
            });
            console.log(req.body.brand);
            console.log(req.body.model);
            console.log(req.body.licensePlate);
        }
        else {
            var newCar = Car({
                brand: req.body.brand,
                model: req.body.model,
                licensePlate: req.body.licensePlate,
                color: req.body.color != null ? req.body.color : 'Unknown'
            });

            newCar.save((err, newCar) => {
                if(err) {
                    res.json({
                        success: false,
                        msg: 'The new car could not be saved!'
                    });
                    console.log(err);
                }
                else {
                    return res.json({
                        success: true,
                        msg: 'New car has been successfully saved!',
                        car: newCar
                    });
                }
            });
        }
    },
}

module.exports = services;