require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/database');

const { registerUser, loginUser } = require('./controllers/authController');
const { clockIn, clockOut, getReports: getAttendanceReports } = require('./controllers/attendanceController');
const { addVehicle, getVehicles, updateVehicle, deleteVehicle } = require('./controllers/vehicleController');
const { sendToGarage, getGarageRecords } = require('./controllers/garageController');
const { addCommission, getCommissions } = require('./controllers/commissionController');
const { addBranch, getBranches } = require('./controllers/branchController');
const { protect, authorize } = require('./middleware/auth');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Connect DB
connectDB();

// --- Auth APIs ---
app.post('/login', loginUser);
app.post('/register', registerUser); // Can add protect/authorize('Admin') if needed

// --- Attendance APIs ---
app.post('/attendance/login', protect, clockIn);
app.post('/attendance/logout', protect, clockOut);
app.get('/attendance/report', protect, getAttendanceReports);

// --- Vehicle APIs ---
app.post('/vehicle/add', protect, authorize('Admin', 'Manager'), addVehicle);
app.get('/vehicle/list', protect, getVehicles);
app.put('/vehicle/update/:id', protect, authorize('Admin', 'Manager'), updateVehicle); // User said PUT /vehicle/update but standard needs ID
app.delete('/vehicle/delete/:id', protect, authorize('Admin'), deleteVehicle);

// --- Garage APIs ---
app.post('/garage/add', protect, authorize('Admin', 'Manager'), sendToGarage);
app.get('/garage/list', protect, getGarageRecords);

// --- Commission APIs ---
app.post('/commission/add', protect, authorize('Admin', 'Manager'), addCommission);
app.get('/commission/report', protect, authorize('Admin', 'Manager'), getCommissions);

// --- Branch APIs ---
app.post('/branch/add', protect, authorize('Admin'), addBranch);
app.get('/branch/list', protect, getBranches);

app.get('/', (req, res) => res.send('Jaffna Vehicle Spot MongoDB API Running'));

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
