require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const path = require('path');
const app = express();
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use('/pdfs', express.static(path.join(__dirname, 'public', 'pdfs')));
app.use('/public', express.static(path.join(__dirname, '..', 'public')));

// routes
app.use('/api/admin', require('./routes/admin'));
app.use('/api/questions', require('./routes/questions'));
app.use('/api/triagem', require('./routes/triagem'));

app.get('/health', (req,res)=>res.json({ok:true}));

const port = process.env.PORT || 3000;
app.listen(port, ()=> console.log('Server started on', port));
