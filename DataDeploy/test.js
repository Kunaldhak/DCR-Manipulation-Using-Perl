let data = {
  'jsonData' : reqDetails,
  'customerPlanFlag': false, 
}
Promise.all([
  fetch('bin/customerDetailsSave', {
      method: "POST",
  	  body: JSON.stringify(data),
      headers: {"Content-type": "application/json; charset=UTF-8"
    }),
    fetch('bin/customerDetailsSave', {
      method: "POST",
  	  body: JSON.stringify(data),
      headers: {"Content-type": "application/json; charset=UTF-8"
    })
]).then(function (responses) {
	return Promise.all(responses.map(function (response) {
		return response.json();
	}));
}).then(function (data) {
	console.log(data);
	//process the data from 2nd call and redirect
}).catch(function (error) {
	console.log(error);
});
