const express = require('express');
const router = express.Router();
const db = require('../db');
const auth = require('../middleware/auth');

// public get questions
router.get('/', async (req,res)=>{
  const q = await db.query('SELECT id,text,type,options FROM questions ORDER BY id');
  res.json(q.rows);
});

// protected create
router.post('/', auth, async (req,res)=>{
  const {text,type,options} = req.body;
  await db.query('INSERT INTO questions(text,type,options) VALUES($1,$2,$3)', [text,type,options||null]);
  res.json({ok:true});
});

router.delete('/:id', auth, async (req,res)=>{
  const id = req.params.id;
  await db.query('DELETE FROM questions WHERE id=$1', [id]);
  res.json({ok:true});
});

module.exports = router;
