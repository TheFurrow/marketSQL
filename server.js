/************************************************
Heavily modified copy of SQL work
Author: 		Jaakko Vanhala (Lecturer, Karelia UAS)
Modifier:	Tuisku Saarelainen (Student, Karelia UAS)

Original work was developed for "linkbank" by
Jaakko Vanhala and his students in Database systems
course. https://github.com/jvanhalen/linkbank/
************************************************/

var express = require('express');
var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var port = 3000;

//Require database
var Database = require('./database/database');
var database = new Database();

app.use(express.static(__dirname + '/client'));

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

//Listeners and senders
io.on('connection', function(socket){
  var address = socket.handshake.address;
  console.log("New connection from " + address);

	//SOCKETS *************************************
	
	//Trigger and wake up on call
  	socket.on('searchEmployee', function(msg){
   	console.log('message: ' + msg);
      msg = JSON.parse(msg);
   	// Do a SQL query in searchEmployee hanlder
    	database.searchEmployee(msg.word, socket);
  	});
  
  	//Trigger and wake up on call
   socket.on('searchConsum', function(msg){
    	console.log('message: ' + msg);
      msg = JSON.parse(msg);
   	// Do a SQL query in searchConsum hanlder
    	database.searchConsum(msg.word, socket);
  	});
  
});

//Listen port 3000 traffic
http.listen(3000, function(){
  console.log('listening on http://localhost:'+port);
});
