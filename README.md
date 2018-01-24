[![Build Status](https://semaphoreci.com/api/v1/brentgreeff/basic_rails_5_api/branches/master/badge.svg)](https://semaphoreci.com/brentgreeff/basic_rails_5_api)

# Events

Basic Rails API for creating, updating and deleting Events.

## Install

I am using rvm, but its not required.

      bundle install

      rake db:create

      rake db:migrate



## Approach

Please run `guard` when changing code.

press [enter] to run all tests.

The tests should be self documenting.

## API

Add user
> POST /users

Login
> POST /authentications

Event list
> GET /events

Create Event
> POST /events

Update Event
> PATCH /events/ID

Delete Event
> DELETE /events/ID

