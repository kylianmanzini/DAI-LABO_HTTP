# Step 5 - Load balancing and sticky sessions

## Sticky session

The simple way to add a sticky session is to add two simple line to the service we want to stick to the user : 
```
      - traefik.http.services.app.loadbalancer.sticky.cookie=true
      - traefik.http.services.app.loadbalancer.sticky.cookie.name=sticky-cookie
```

In our case, we want the apache web servers to stick. This way, a user will send request to the same server he connected to first.

## Load balancing

By default, traefik does use a round robin load balancing system. So we did not had to change anything for it to work. 