/************************************************
Heavily modified copy of SQL work
Author: 		Jaakko Vanhala (Lecturer, Karelia UAS)
Modifier:	Tuisku Saarelainen (Student, Karelia UAS)

Original work was developed for "linkbank" by
Jaakko Vanhala and his students in Database systems
course. https://github.com/jvanhalen/linkbank/
************************************************/

function Database() {

  if(typeof this.mysql == "undefined") {
    this.init();
  }
}

// Set database log in and select database
Database.prototype.init = function() {

	var mysql = require('mysql');
	
	this.connection = mysql.createConnection({
		host : 'localhost',
		user : 'root',
		password : 'testi1234',
		database : 'market'
	});
},


// Database handlers

// searchEmployee -handler
Database.prototype.searchEmployee = function(word, socket) {
  console.log("search:", word);

//Select first name and surname from employee table
var query = this.connection.query("SELECT etunimi, sukunimi FROM henkilokunta WHERE etunimi LIKE '%" + word + "%' OR sukunimi LIKE '%" + word + "%'", function(err, rows, fields) {
		
		//Throw error if there were one
      if(err) {        
      	console.log("search query failed:", err);   
      }
      //Else carry on
      else 
      {	
      	//Emit found data to search-response socket
		   socket.emit('search-response', JSON.stringify(rows));
		  	console.log("found", rows); 
      }
    });
};

// searchConsum -handler
Database.prototype.searchConsum = function(word, socket) {
  console.log("search:", word);

//Select product name and its description from product table
var query = this.connection.query("SELECT tuotenimi, tuoteseloste FROM tuote WHERE tuotenimi LIKE '%" + word + "%'", function(err, rows, fields) {
		
		//Throw error if there were one
      if(err) {        
      	console.log("search query failed:", err);   
      }
      //Else carry on
      else 
      {	
      	//Emit found data to search-response socket
      	socket.emit('search-response', JSON.stringify(rows));
     		console.log("found", rows);
      }
    });
};

module.exports = Database;
