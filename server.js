const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const path = require('path');

require('dotenv').config();

const app = express();
const HOSTNAME = process.env.APP_HOSTNAME;
const PORT = process.env.APP_PORT;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));
app.use('/uploads', express.static('/var/isetbz/uploads'));

// MongoDB connection
const uri = `mongodb://${process.env.MONGO_USERNAME}:${process.env.MONGO_PASSWORD}@${process.env.MONGO_HOST}:${process.env.MONGO_PORT}/${process.env.MONGO_DATABASE}`;
mongoose.connect(uri);

// Define a schema and model
const DataSchema = new mongoose.Schema({
    notePresident: JSON,
    noteEncadrant: JSON,
    test: String,
});

const DataModel = mongoose.model(`${process.env.MONGO_COLLECTION_I}`, DataSchema);

// Variables
let student_id = null;
let noteEncadrant = null;

// Routes
app.get('/api/data', async (req, res) => {
    cin = req.query.cin;
    try {
        const data = await DataModel.find({ cin: cin });
        if (!data) {
            return res.status(404).json({ error: 'Data not found' });
        }
        student_id = data[0]._id;
        res.json(data);
    } catch (error) {
        console.error('Error retrieving data:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/api/president', async (req, res) => {
    // const student_id = req.params.id;
    const notePresident = req.body;
    console.log(student_id, notePresident);
    try {

        const data2 = await DataModel.findByIdAndUpdate(student_id, { $set: { notePresident: notePresident }}, { new: true });
        return res.json({ msg: 'Données enregistrées avec succès !' });

    } catch (error) {
        res.status(500).json({ error: 'Error updating data.' });
    }
});

app.post('/api/encadrant', async (req, res) => {
    noteEncadrant = req.body;
    console.log(studentId, cin, noteEncadrant);

try {

    await DataModel.findByIdAndUpdate('6825b66fa8f51c642552bf43', { $set: noteEncadrant }, { new: true });
    return res.json({ msg: 'Données enregistrées avec succès !' });

  } catch (error) {
    res.status(500).json({ error: 'Error updating data.' });
  }

});

app.listen(PORT, HOSTNAME, () => {
    console.log(`Server is running on http://${HOSTNAME}:${PORT}`);
});
