const express = require('express');
const router = express.Router();
const db = require('../db');
const generatePDF = require('../utils/pdfGenerator');
const auth = require('../middleware/auth');

// POST save triagem (public)
router.post('/', async (req,res)=>{
  const {patient_name, answers} = req.body;
  try{
    const r = await db.query('INSERT INTO triagem_respostas(patient_name,answers) VALUES($1,$2) RETURNING id', [patient_name, answers]);
    const id = r.rows[0].id;
    const pdfUrl = await generatePDF(id, patient_name, answers);
    await db.query('UPDATE triagem_respostas SET pdf_url=$1 WHERE id=$2', [pdfUrl, id]);
    res.json({id, pdfUrl});
  }catch(e){ console.error(e); res.status(500).json({error:'db'}); }
});

// admin list triagens
router.get('/', auth, async (req,res)=>{
  const q = await db.query('SELECT id, patient_name, answers, pdf_url, created_at FROM triagem_respostas ORDER BY created_at DESC LIMIT 1000');
  res.json(q.rows);
});

module.exports = router;
