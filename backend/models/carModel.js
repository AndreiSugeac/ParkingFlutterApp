const mongoose = require('mongoose');
const AutoIncrement = require('mongoose-sequence')(mongoose);

const Schema = mongoose.Schema;

const carSchema = new Schema({
    _id: Number,
    brand: {
        type: String,
        require: true
    },
    model: {
        type: String,
        require: true
    },
    licensePlate: {
        type: String,
        require: true
    },
    color: {
        type: String,
        require: false
    }
}, { _id: false });
carSchema.plugin(AutoIncrement);

module.exports = mongoose.model('Car', carSchema);