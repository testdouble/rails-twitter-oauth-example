# Rails + Twitter OAuth Example App

This is a Ruby on Rails application that includes example code to add log in
with Twitter via its OAuth provider API. It's meant to be paired with a
forthcoming blog post explaining how the implementation works.

## Setting up your Twitter application

First, in order to do anything you need a Twitter developer account, which
Twitter sadly doesn't hand out like candy any more. [Apply for a developer
account](https://developer.twitter.com/en/apply-for-access) if you don't already
have one and be prepared to wait a few months.

If you do already have a developer account, you'll need to:

1. Create an application in the [Twitter developer
   portal](https://developer.twitter.com/en/portal/dashboard)
2. Enable "3-legged OAuth" for the application, and set the callback URL to
   `http://localhost:3000/callback` (you can add additional callback URLs for other
   environments later)
3. In this project `cp .env.example .env` and set as environment
   variables each of your app's OAuth consumer key & secret, as well as the
   above callback URL

## Getting this Rails app running

To set up and run this server locally, run these magical commands:

```
$ bundle install
$ yarn install
$ bin/rake db:create db:migrate
$ bin/rails server
```

If all goes well, this should start a server at
[localhost:3000](http://localhost:3000)


