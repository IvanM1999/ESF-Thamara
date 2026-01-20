const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');

module.exports = async function generatePDF(id, name, answers){
  const dir = path.join(__dirname, '..', 'public', 'pdfs');
  if(!fs.existsSync(dir)) fs.mkdirSync(dir, {recursive:true});
  const filename = `triagem_${id}.pdf`;
  const filepath = path.join(dir, filename);
  return new Promise((resolve, reject)=>{
    const doc = new PDFDocument({margin:40, size:'A4'});
    const stream = fs.createWriteStream(filepath);
    doc.pipe(stream);
    doc.fontSize(18).text('Triagem - ESF Thamara Rodriguez', {align:'center'});
    doc.moveDown();
    doc.fontSize(12).text(`Data: ${new Date().toLocaleString()}`);
    doc.moveDown();
    doc.fontSize(14).text(`Paciente: ${name||'Não informado'}`);
    doc.moveDown();
    doc.fontSize(12);
    for(const [k,v] of Object.entries(answers||{})){
      doc.text(`${k.replace(/^q_/, '')}: ${v}`);
      doc.moveDown(0.2);
    }
    doc.end();
    stream.on('finish', ()=> resolve(`/pdfs/${filename}`));
    stream.on('error', reject);
  });
};
