// HELPER FUNCTIONS
function theDate() {
    const now = new Date();

    // Extract day, month, and year
    const day = String(now.getDate()).padStart(2, '0'); // Add leading zero if needed
    const month = String(now.getMonth() + 1).padStart(2, '0'); // Months are 0-based, so add 1
    const year = now.getFullYear();

    // Format the date as DD/MM/YYYY
    return `${day}/${month}/${year}`;
}

function theTime() {
    const now = new Date();

    // Extract hours, minutes, and seconds
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const seconds = String(now.getSeconds()).padStart(2, '0');

    // Format the time as HH:MM:SS
    const time = `${hours}:${minutes}:${seconds}`;

    return `${time}`;
}

const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const { exec } = require('child_process');

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
app.use('/dir_pv', express.static(path.join(__dirname, 'dir_pv')));

// MongoDB connection
const uri = `mongodb://${process.env.MONGO_USERNAME}:${process.env.MONGO_PASSWORD}@${process.env.MONGO_HOST}:${process.env.MONGO_PORT}/${process.env.MONGO_DATABASE}`;
mongoose.connect(uri);

// Define a schema and model
const DataSchema = new mongoose.Schema({
    notePresident: JSON,
    noteRapporteur: JSON,
    noteEncadrant: JSON,
    date: JSON,
    auth: Boolean,
    obs: String,
});

const DataModel = mongoose.model(`${process.env.MONGO_COLLECTION_I}`, DataSchema);

// Variables
let cin = null;

// Routes
app.get('/api/data', async (req, res) => {
    cin = req.query.cin;
    try {
        const data = await DataModel.find({ cin: cin });
        if (!data) {
            return res.status(404).json({ error: 'Data not found' });
        }
        cin = data[0].cin;
        res.json(data);
    } catch (error) {
        console.error('Error retrieving data:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/api/president', async (req, res) => {
    const notePresident = req.body;
    const date = { 'jour': theDate(), 'heure': theTime() };
    try {
        await DataModel.findByIdAndUpdate(student_id, { $set: { notePresident: notePresident, date: date, auth: false } }, { new: true });
        return res.json({ msg: 'Données enregistrées avec succès !' });
    } catch (error) {
        res.status(500).json({ error: 'Error updating data.' });
    }
});

app.post('/api/rapporteur', async (req, res) => {
    const noteRapporteur = req.body;
    try {
        await DataModel.findByIdAndUpdate(student_id, { $set: { noteRapporteur: noteRapporteur } }, { new: true });
        return res.json({ msg: 'Données enregistrées avec succès !' });
    } catch (error) {
        res.status(500).json({ error: 'Error updating data.' });
    }
});

app.post('/api/encadrant', async (req, res) => {
    const noteEncadrant = req.body;
    try {
        await DataModel.findByIdAndUpdate(student_id, { $set: { noteEncadrant: noteEncadrant } }, { new: true });
        return res.json({ msg: 'Données enregistrées avec succès !' });
    } catch (error) {
        res.status(500).json({ error: 'Error updating data.' });
    }
});

app.post('/api/obs', async (req, res) => {
    const obs = req.body.obs;
    try {
        await DataModel.findByIdAndUpdate(student_id, { $set: { obs: obs } }, { new: true });
        return res.json({ msg: 'Données enregistrées avec succès !' });
    } catch (error) {
        res.status(500).json({ error: 'Error updating data.' });
    }
});

app.post('/api/print', (req, res) => {
    const cin = req.body.cin;
    const pv_generator = `./pv_generator.sh ${cin}`;

    exec(pv_generator, (error, stdout, stderr) => {
        if (error) {
            return res.status(500).json({ error: error.message });
        }
        res.json({ output: stdout, error: stderr });
    });
});

app.listen(PORT, HOSTNAME, () => {
    console.log(`Server is running on http://${HOSTNAME}:${PORT}`);
});
