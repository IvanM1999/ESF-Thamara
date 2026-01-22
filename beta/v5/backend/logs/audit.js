import fs from "fs";
export function logEvent(evt){
  fs.appendFileSync("audit.log", JSON.stringify(evt) + "\n");
}