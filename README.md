# README

Fork of the original project of Luca Tironi https://github.com/lucatironi/example_rails_api

The original version is with Rails4 and all works fine.
With **Rails 5alpha** there is a problem when I test the controller, **the spec returns always 200 also for unauthorized users (it should be 401)**. Instead the **body response is correct**.

I don't know the problem is due to **Warden stub** for controller test ([spec/support/warden.rb] (https://github.com/nickgnd/example_rails_api/blob/test/rails5alpha/spec/support/warden.rb)) or maybe to [ActionDispatch::Response.create](https://github.com/rails/rails/blob/5217db2a7acb80b18475709018088535bdec6d30/actionpack/lib/action_dispatch/http/response.rb#L133).

### To reproduce it:
1. Clone it!
2. ```bundle install```
3. ```bin/rake db:migrate```
4. ```bin/rake db:test:prepare```
5. ```bundle exec spring binstub rspec```
6. ```bin/rspec spec/controllers/customers_controller_spec.rb```

--> **it fails, returns 200 instead of 401 as response status.**

	
More precisely, fails this shared spec: https://github.com/nickgnd/example_rails_api/blob/test/rails5alpha/spec/support/authenticated_api_controller.rb that is included in customer controller spec

```bash
CustomersController behaves like authenticated_api_controller authentiation returns unauthorized request without email and token
     Failure/Error: expect(response.status).to eq(401)
       
       expected: 401
            got: 200
       
       (compared using ==)
      Shared Example Group: "authenticated_api_controller" called from ./spec/controllers/customers_controller_spec.rb:14

```


### Below the step to try it in Development Env with simple **Curl**:
0. ```bin/rake db:migrate && bin/rake db:seed```   # seed the database
1. ```bin/rails server```                          # start the server on localhost:3000
2. ```curl -i -X POST -H "Content-Type:application/json" -d '{ "user": { "email": "admin@example.com", "password": "password" } }' http://localhost:3000/sessions.json```             # Obtain the token with right credentials
3. ```curl -i -X GET -H "Content-Type:application/json" -H "X-User-Email:admin@example.com" -H "X-Auth-Token:wQgPRHhPeLqjLDCrZU" http://localhost:3000/customers.json```            # Try with the **WRONG** token

--> **IT RETURNS PROPERLY 401**

```bash
curl -i -X POST -H "Content-Type:application/json" -d '{ "user": { "email": "admin@example.com", "password": "password" } }' http://localhost:3000/sessions.json     
HTTP/1.1 200 OK 
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET,POST,PUT,DELETE,OPTIONS
Access-Control-Allow-Headers: Content-Type,Accept,X-User-Email,X-Auth-Token
Content-Type: application/json; charset=utf-8
Etag: W/"82160d1625d7434b8d3dd527b3bbe44f"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: 0a4ca527-f50b-4c0e-b5db-f8b243535d10
X-Runtime: 0.132585
Server: WEBrick/1.3.1 (Ruby/2.2.3/2015-08-18)
Date: Sat, 28 Nov 2015 20:19:44 GMT
Content-Length: 74
Connection: Keep-Alive

{"user_email":"admin@example.com","auth_token":"VrTtd6drmmQUyydx6tMHYhFD"}%  
```
```bash
curl -i -X GET -H "Content-Type:application/json" -H "X-User-Email:admin@example.com" -H "X-Auth-Token:wQgPRHhPeLqjLDCrZU" http://localhost:3000/customers.json 
HTTP/1.1 401 Unauthorized 
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET,POST,PUT,DELETE,OPTIONS
Access-Control-Allow-Headers: Content-Type,Accept,X-User-Email,X-Auth-Token
Content-Type: application/json; charset=utf-8
X-Request-Id: 430cc842-a033-4d93-a19a-461eb9d971d4
X-Runtime: 0.033793
Server: WEBrick/1.3.1 (Ruby/2.2.3/2015-08-18)
Date: Sat, 28 Nov 2015 20:29:16 GMT
Content-Length: 35
Connection: Keep-Alive

{"errors":["Unauthorized Request"]}%  
```
