# Step 4 - Fetch javascript requests

The goal of this step was to get data from our api and update our website with the data.

We use the ``fetch()`` function in javascript to get our data.

First we need to add a script tag at the end of the ``index.html`` of the apache web server. In this template we have differents HTML tag with set ids, such as ``nom``, ``espece`` or ``status``.

To modify the content, we use functions called ``populateOk(data)`` and ``populateError()``, to add content when we received data from the api and add default content when there is a problem receiving the data. To modify the content, we simply select the correct element by id and modify the content in the populate function, like this:
```
    const nom = document.getElementById('nom'),
    ...
	nom.textContent = ("Name : " + res.name);

```
To get the data, we use this function: 
```
	function populatePage() {
		const fetchPromise = fetch("http://localhost/api");
		console.log(fetchPromise);
		fetchPromise
		.then((response) => {
			if (!response.ok){
				populateError();
				throw new Error(`HTTP error: ${response.status}`);
			}
			return response.json();
		})
		.then((data) => {
			console.log("data received");
			populateOk(data);
		})
		.catch((error) => {
			populateError();
			console.error(`api did not work: ${error}`);
		})
	}
```

It work this way: 

First, we ask data to the api by using ``fetch("http://localhost/api")``. This way, we can get the data from the url, which is our api.

Second, we use the ``.then`` and ``.catch``. The ``.then`` will be triggered when the ``fetch()`` has received an HTTP response from the api. We then need to check if the HTTP response was successfull, which mean the HTTP status code is between 200 and 299. We do that using ``response.ok``. The ``.catch`` will be triggered if there was a problem during the ``fetch()``.

Lastly, we send the payload we received to the populate functions.

To make a request when the page is loaded and every few second, we need to add this code at the end: 

```
	populatePage();
	window.setInterval(populatePage, 6000);
```

It will simply call the function once at the beginning and once every 6 seconds.