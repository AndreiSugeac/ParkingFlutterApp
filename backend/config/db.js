const mongoose = require('mongoose');
const dbConfig = require('./dbConfig');

const connectDb = async() => {
    try{
        const conn = await mongoose.connect(dbConfig.database, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
            useFindAndModify: true
        });
        console.log('Connection to DB established on: ' + conn.connection.host);
    }
    catch(err) {
        console.log(err);
        process.exit(1);
    }
}

module.exports = connectDb;