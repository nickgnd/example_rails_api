# README

Fork of the original project of Luca Tironi https://github.com/lucatironi/example_rails_api

The original version is with Rails4 and all works fine.
With **Rails 5alpha** there is a problem with **Warden stub** for controller test (spec/support/warden.rb), it returns the wrong status response: 200 instead of 401.


1. Clone it!
2. bundle install
3. bin/rake db:migrate
4. bundle exec spring binstub rspec
5. bin/spec spec/controllers/customers_controller_spec.rb
--> it returns 200 instead of 401

```bash
CustomersController behaves like authenticated_api_controller authentiation returns unauthorized request without email and token
     Failure/Error: expect(response.status).to eq(401)
       
       expected: 401
            got: 200
       
       (compared using ==)
      Shared Example Group: "authenticated_api_controller" called from ./spec/controllers/customers_controller_spec.rb:14

```
