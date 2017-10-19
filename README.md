# Group events

Basic Rails API for creating, updating and deleting Events.

## Install

I am using rvm, but its not required.

      bundle install

      rake db:create

      rake db:migrate



## Approach

I only do TDD, - please run `guard`

press [enter] to run all tests.

tests should be self documenting.

I have not dealt with many edge cases, since I don't see any point in adding code that has no real world value.

This is just "the simplest thing that works".

## Next steps

* Deploy to staging ( can be heroku ) so it can be tested with a client.
* Ideally its tested with the real client that is going to use it.
* Go end-to-end asap, so that we can see the whole picture works.
* Spec additional tasks and issues.
