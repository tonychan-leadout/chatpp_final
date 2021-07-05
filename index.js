const WebSocket = require('ws')
const express = require('express')
const moment = require('moment')
const app = express()
const port = 7878; //port for https

app.use(
    express.urlencoded({
      extended: true
    })
  )
  
app.use(express.json())
app.get('/', (req, res) => {
    res.send("Hello World");
});
app.post('/getstatus', (req, res) => {
    var MongoClient = require('mongodb').MongoClient;
    var url = "mongodb+srv://Hin:tony1007@cluster0.1a24r.mongodb.net/test";
    
    MongoClient.connect(url, function(err, db) {
        if (err) throw err;
        var dbo = db.db("Hin");
        var whereStr = {"name":req.body.id}
        //var whereStr = {"name":req.body.id,"receiver":req.body.receiver};  // 查询条件
        dbo.collection("user").find(whereStr).toArray(function(err, result) {
            if (err) throw err;
            console.log(result);
            res.send(result);
            db.close();
        });
    });
    //res.send("dsds World");
});
app.post('/getuser', (req, res) => {
    var MongoClient = require('mongodb').MongoClient;
    var url = "mongodb+srv://Hin:tony1007@cluster0.1a24r.mongodb.net/test";
    
    MongoClient.connect(url, function(err, db) {
        if (err) throw err;
        var dbo = db.db("Hin");
        var whereStr = {$or :[{"name":req.body.id},{"receiver":req.body.id}]}
        //var whereStr = {"name":req.body.id,"receiver":req.body.receiver};  // 查询条件
        dbo.collection("message").find(whereStr).toArray(function(err, result) {
            if (err) throw err;
            console.log(result);
            res.send(result);
            db.close();
        });
    });
    //res.send("dsds World");
});
app.post('/getmsg', (req, res) => {
    var MongoClient = require('mongodb').MongoClient;
    var url = "mongodb+srv://Hin:tony1007@cluster0.1a24r.mongodb.net/test";
    
    MongoClient.connect(url, function(err, db) {
        if (err) throw err;
        var dbo = db.db("Hin");
        var whereStr = {$or :[{"name":req.body.id,"receiver":req.body.receiver},{"name":req.body.receiver,"receiver":req.body.id}]}
        //var whereStr = {"name":req.body.id,"receiver":req.body.receiver};  // 查询条件
        dbo.collection("message").find(whereStr).toArray(function(err, result) {
            if (err) throw err;
            console.log(result);
            res.send(result);
            db.close();
        });
    });
    //res.send("dsds World");
});
app.get('/get', (req, res) => {
    var MongoClient = require('mongodb').MongoClient;
    var url = "mongodb+srv://Hin:tony1007@cluster0.1a24r.mongodb.net/test";
    
    MongoClient.connect(url, function(err, db) {
        if (err) throw err;
        var dbo = db.db("Hin");
        var whereStr = {"status":'Hello i am use chat'};  // 查询条件
        dbo.collection("user").find({}).toArray(function(err, result) {
            if (err) throw err;
            console.log(result);
            res.send(result);
            db.close();
        });
    });
    //res.send("dsds World");
});
app.post('/register', (req, res) => {
    var MongoClient = require('mongodb').MongoClient;
    var url = "mongodb+srv://Hin:tony1007@cluster0.1a24r.mongodb.net/test";
                    
    MongoClient.connect(url, function(err, db) {
        if (err) throw err;
        var dbo = db.db("Hin");
        var myobj = { name: req.body.name, email: req.body.email, password: req.body.password ,receiver: req.body.receiver,status:req.body.status};
        dbo.collection("user").insertOne(myobj, function(err, res) {
            if (err) throw err;
            console.log("文档插入成功");
            db.close();
        });
    });
    res.send("register successful");
});
app.post('/login', (req, res) => {
    var MongoClient = require('mongodb').MongoClient;
    var url = "mongodb+srv://Hin:tony1007@cluster0.1a24r.mongodb.net/test";
                    
    MongoClient.connect(url, function(err, db) {
        if (err) throw err;
        var dbo = db.db("Hin");
        var whereStr = {"email":req.body.email, "password" : req.body.password};  // 查询条件
        dbo.collection("user").find(whereStr).toArray(function(err, result) {
            var data=[];
            if (err) throw err;
            console.log(result);
            data.push(result[0].name,result[0].receiver,result[0].email,result[0].status)
            res.send(data);
            // var boardws = webSockets['01'] //check if there is reciever connection
            // if (boardws){
            //     var cdata = "{'cmd':'" + data.cmd + "','userid':'"+result[0].name+"', 'receiver':'"+result[0].receiver+"'}";
            //     boardws.send(cdata); //send message to reciever
            //     ws.send(data.cmd + ":success");
            // }
            db.close();
            console.log(result[0].name+" Connected")
        });
    });
    console.log(req.body)
});

    

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
});
var  webSockets = {}

const wss = new WebSocket.Server({ port: 6060 }) //run websocket server with port 6060
wss.on('connection', function (ws, req)  {
    var userID = req.url.substr(1) //get userid from URL ip:6060/userid 
    webSockets[userID] = ws //add new user to the connection list

    console.log('User ' + userID + ' Connected ') 

    ws.on('message', message => { //if there is any message
        console.log(message);
        var datastring = message.toString();
        if(datastring.charAt(0) == "{"){
            datastring = datastring.replace(/\'/g, '"');
            var data = JSON.parse(datastring)
            if(data.auth == "chatapphdfgjd34534hjdfk"){
                if(data.cmd == 'send'){ 
                    var boardws = webSockets[data.receiver] //check if there is reciever connection
                    var MongoClient = require('mongodb').MongoClient;
                        var url = "mongodb+srv://Hin:tony1007@cluster0.1a24r.mongodb.net/test";
                        
                        MongoClient.connect(url, function(err, db) {
                            if (err) throw err;
                            var dbo = db.db("Hin");
                            var myobj = { name: data.userid, receiver: data.receiver, message: data.msgtext };
                            dbo.collection("message").insertOne(myobj, function(err, res) {
                                if (err) throw err;
                                console.log("文档插入成功");
                                db.close();
                            });
                        });
                    if (boardws){
                        var cdata = "{'cmd':'" + data.cmd + "','userid':'"+data.userid+"', 'sendid':'"+data.receiver+"','msgtext':'"+data.msgtext+"'}";
                        boardws.send(cdata); //send message to reciever
                        ws.send(data.cmd + ":success");
                        
                    }
                    
                    else{
                        console.log("receiver offline");
                        ws.send(data.cmd + ":error");
                    }
                }else{
                    console.log("No send command");
                    ws.send(data.cmd + ":error");
                }
            }else{
                console.log("App Authincation error");
                ws.send(data.cmd + ":error");
            }
        }else{
            console.log("Non JSON type data");
            ws.send(data.cmd + ":error");
        }
    })

    ws.on('close', function () {
        var userID = req.url.substr(1)
        delete webSockets[userID] //on connection close, remove reciver from connection list
        console.log('User Disconnected: ' + userID)
    })
    
    ws.send('connected'); //innitial connection return message
})