# Test Club

[https://tibo-test-club.herokuapp.com/](https://tibo-test-club.herokuapp.com/)

Rails project that serves as an introduction to TDD.

We have a User model. A user can sign-up with his first/last name, email address and password.

When logged in he has access to the list of users in the club.

You can visit someone's page to see his profile but you are only allowed to modify your own.

We wrote a battery of tests to make sure everything runs smoothly, using rails default test library : Minitest.

## Installation

After cloning the repo, make sure you have postgres installed on your machine.

From there :
```sh
$ createdb test-club_development
$ createdb test-club_test
$ createuser test-club --createdb
```

To install the app dependencies, start the db and seed it :
```sh
$ bundle install
$ rails db:migrate
$ rails db:seed
```

To start the run the app locally
```sh
$ rails s
```
