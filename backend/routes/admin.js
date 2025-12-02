const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../db');

// POST /api/admin/login
router.post('/login', async (req,res)=>{
  const {username,password} = req.body;
  if(!username || !password) return res.status(400).json({error:'missing'});
  const q = await db.query('SELECT * FROM admin_users WHERE username=$1',[username]);
  const user = q.rows[0];
  if(!user) return res.status(400).json({error:'invalid'});
  const ok = await bcrypt.compare(password, user.password_hash);
  if(!ok) return res.status(400).json({error:'invalid'});
  const token = jwt.sign({id:user.id,username:user.username}, process.env.JWT_SECRET, {expiresIn:'8h'});
  res.json({token});
});

// POST create admin (for initial setup) - protected by a setup token env var
router.post('/create', async (req,res)=>{
  const setup = req.headers['x-setup-token'];
  if(setup !== process.env.SETUP_TOKEN) return res.status(403).json({error:'forbidden'});
  const {username,password} = req.body;
  const hash = await bcrypt.hash(password, 10);
  try{
    await db.query('INSERT INTO admin_users(username,password_hash) VALUES($1,$2)', [username, hash]);
    res.json({ok:true});
  }catch(e){ res.status(500).json({error:'db'}); }
});

module.exports = router;
