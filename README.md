# QuMailer

QuMailer is a library for the asynchronous delivery of emails sent out by ActionMailer in Rails 3 applications. It is heavily inspired by [ResqueMailer](https://github.com/zapnap/resque_mailer).

Email jobs created by QuMailer are processed by [Qu](https://github.com/bkeepers/qu), a Ruby library for queuing and processing background jobs.

## Installation

It is assumed that you are using Qu. If you aren’t already using it, please visit the [Qu project page](https://github.com/bkeepers/qu) for details on getting set up.

### Rails 3

Add the QuMailer gem to your `Gemfile`.

``` ruby
gem 'qu_mailer'
```

## Usage

Include QuMailer in your ActionMailer subclass(es):

``` ruby
class MyMailer < ActionMailer::Base
  include Qu::Mailer
end
```

Fire up Qu with a 'mailer' queue:

``` sh
$ bundle exec rake qu:work QUEUES=mailer,default
```

Now, when you send a `deliver` message to an action in `MyMailer`, it will be placed on Qu’s *mailer* queue, and a Qu worker will deliver it in due course. If you want to bybass Qu in a particular scenario and send the email synchronously, then use `deliver!`.

It is recommended that instead of passing objects to your emails as parameters, record identifiers are used instead. Jobs are handled in a separate process.

## Configuration

### Queue Name

QuMailer defaults to a queue called `mailer`. You can change the name of the queue using an initializer. 

`config/initializers/qu_mailer.rb`:

``` ruby
  Qu::Mailer.default_queue_name = 'asynchronous_electronic_mailbox'
```

### Excluded Environments

You may want to prevent QuMailer from sending out email in certain environments. By default QuMailer exludes the test environment. You may add additional excluded environments using an initializer.

`config/initializers/qu_mailer.rb`:

``` ruby
  Qu::Mailer.excluded_environments << :cucumber
```
