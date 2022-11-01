var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res) {
  res.send('respond with a api');
});

/* Say Something */
router.post('/saysomt', function(req, res){
 try
 {
  var data = req.body;
  res.send(composeGreet(data.name));
 }catch(e)
 {
  res.send('something bad happen');
 }
});

var composeGreet= function(name)
{
  return "hello " + name +"\n";
};


module.exports = router;
module.exports.composeGreet = composeGreet;
