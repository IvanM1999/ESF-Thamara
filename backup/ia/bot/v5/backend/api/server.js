import express from "express";
import cors from "cors";
import { handleChat, triggerEmergency } from "../services/chatService.js";

const app = express();
app.use(cors());
app.use(express.json());

app.post("/api/chat", handleChat);
app.post("/api/emergency", triggerEmergency);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log("IA ESF ENTERPRISE ONLINE"));