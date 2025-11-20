const dotenv = require('dotenv');
const cors = require('cors');
const session = require('express-session');
dotenv.config();

var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

const sequelize = require('./config/database');

// Test database connection and sync models
sequelize.authenticate()
  .then(() => {
    console.log('Database connected!');
    return sequelize.sync({ alter: true }); // Use alter: true for development
  })
  .then(() => {
    console.log('Database synced!');
  })
  .catch((err) => {
    console.error('Database error:', err);
  });

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var apiRouter = require('./routes/api');
var adminRouter = require('./routes/admin');
var organizerRouter = require('./routes/organizer');
var paymentRouter = require('./routes/payment');
var webhookRouter = require('./routes/webhook');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// Session configuration
app.use(session({
  secret: process.env.SESSION_SECRET || 'your-secret-key',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production', // Use HTTPS in production
    maxAge: 24 * 60 * 60 * 1000, // 24 hours
    sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'lax'
  }
}));

// CORS configuration - Allow frontend domain
const allowedOrigins = process.env.NODE_ENV === 'production'
  ? [process.env.FRONTEND_URL]
  : ['http://localhost:3001', 'http://localhost:5173', 'http://127.0.0.1:3001'];

app.use(cors({
  origin: function (origin, callback) {
    // Allow requests with no origin (mobile apps, Postman, etc.)
    if (!origin) return callback(null, true);

    if (allowedOrigins.indexOf(origin) !== -1 || process.env.NODE_ENV !== 'production') {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true
}));

app.use(logger('dev'));
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: false, limit: '50mb' }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
// Serve uploads from public/uploads for admin/api uploads
app.use('/uploads', express.static(path.join(__dirname, 'public/uploads')));
// Also serve organizer uploads from uploads folder
app.use('/organizer-uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/admin', adminRouter);  // Admin routes di luar /api
app.use('/api/organizer', organizerRouter);  // Organizer routes
app.use('/api/payment', paymentRouter);  // Payment routes
app.use('/webhook', webhookRouter);  // Webhook routes (no /api prefix)
app.use('/api', apiRouter);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
