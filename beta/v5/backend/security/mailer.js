import nodemailer from "nodemailer";

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  auth: { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS }
});

export async function sendEmergencyMail(event){
  await transporter.sendMail({
    from: process.env.SMTP_USER,
    to: "dsbrti2022@gmail.com",
    subject: "ALERTA CRÍTICO - IA ESF",
    text: JSON.stringify(event, null, 2)
  });
}