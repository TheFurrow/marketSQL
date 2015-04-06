/************************************************
Heavily modified copy of SQL work
Author: 		Jaakko Vanhala (Lecturer, Karelia UAS)
Modifier:	Tuisku Saarelainen (Student, Karelia UAS)

Original work was developed for "linkbank" by
Jaakko Vanhala and his students in Database systems
course. https://github.com/jvanhalen/linkbank/
************************************************/

//File required to read sockets
var socket = io();

//Get data from html input
$('#sendBrowserInputData').click(function(event){
  event.preventDefault();
	
	//Get data from insertInput and radio item value
  	var request = {
  		word: $('#insertInput').val(),
  		item: $('input:checked').val()
  	}
  		//If data word happens to be empty, we let user know about it
  		if(request.word === "" || request.word === " ") 
  		{
  			var intoTheHtml = document.getElementById('dataTotal').innerHTML = '<div style="color:red;"><p>Tyhjä lomake</p></div>';
  		}
  		//Otherwise we carry on and check radio value and choose path
  		//Radio value is employee
		else if (request.item == "employee")
		{ 
			var intoTheHtml = document.getElementById('dataTotal').innerHTML = "";
			console.log("search with:", request);
			//We emit to searchEmployee-socket a request to handle our data
	  		socket.emit('searchEmployee', JSON.stringify(request));
		}
		//Radio value is something else and we have only 2 choises
		//employee or consum
		else
		{
			var intoTheHtml = document.getElementById('dataTotal').innerHTML = "";
			console.log("search with:", request);
			//We emit to searchConsum-socket a request to handle our data
	  		socket.emit('searchConsum', JSON.stringify(request));
		}

});

//Trigger on call
socket.on('search-response', function(msg){
	msg = JSON.stringify(msg);
  	console.log("search response: " + msg);
  	
  	//Empty insertInput value
	$('#insertInput').val('');
	
  	//Print data if search query value was not the following result
  	if(msg !== '"[]"') 
	{
		//Lets make data more eye-friendly by removing most of symbols
		var intoTheHtml = document.getElementById('dataTotal').innerHTML = "Hakutulokset" + msg.replace(/etunimi/g, "<hr/>Nimi= ").replace(/sukunimi/g, " ").replace(/tuoteseloste/g, " <br/>Tuoteseloste= ").replace(/\u007B/g, "").replace(/tuotenimi/g, "<hr />Tuote= ").replace(/\u005C/g, "").replace(/\u007D/g, "").replace(/\u005B/g, "").replace(/\u005D/g, "").replace(/\u0022/g, "").replace(/\u002C/g, "").replace(/\u003A/g, "") + '<hr/>';
	}
	//Else search query value happened to be exact value as previous if-statement
	else 
	{
		//Lets tell client that there was no matchable result
  		var intoTheHtml = document.getElementById('dataTotal').innerHTML = '<div style="color:red;"><h3>Oh noes!</h3><p>Emme löytäneet yhtään bittiä :(<br>Kenties uusi yritys,  <b>eiks je</b>?</p></div>';
	}

//end of trigger
});
