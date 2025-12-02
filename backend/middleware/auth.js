const jwt = require('jsonwebtoken');
module.exports = function(req,res,next){
  const auth = req.headers.authorization;
  if(!auth) return res.status(401).json({error:'no_auth'});
  const token = auth.split(' ')[1];
  try{
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    req.user = payload;
    next();
  }catch(e){
    return res.status(403).json({error:'invalid_token'});
  }
};
