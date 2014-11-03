[![Build Status](https://magnum.travis-ci.com/teambox/redbooth-ruby.svg?token=DytWKainUGNzXxdrekWH&branch=feature/tasks)](https://magnum.travis-ci.com/teambox/redbooth-ruby)

Redbooth-Ruby
======

This is a Ruby wrapper for redbooth's API.

Documentation
=====

We use YARD for documentation.

Usage
======

First, you've to install the gem

```Ruby
  gem install redbooth-ruby
```

and require it

```Ruby
  require 'redbooth'
```

and set up your app credentials


```Ruby
  Redbooth.config do |configuration|
    configuration[:consumer_key] = '_your_consumer_key_'
    configuration[:consumer_secret] = '_your_consumer_secret_'
  end
```

in fact this last step is optional (yes! we support multiple applications) but if as most fo the humans you use only one redbooth app, this is the easyest way to go.


Oauth
=====

*[Redbooth oauth2 API documentation](https://www.redbooth.com/developer/documentation#authentication)*

using omniauth? :+1: good choice, just try this gem

  *[teambox/omniauth-redbooth](https://github.com/teambox/omniauth-redbooth)*

not using omniauth,? no prob oauth implementation comming soon

  ...


Client
======

Everything starts with the client, once you have the user credentials you should create a session and a client to start interaction with the API

```Ruby
  session = Redbooth::Session.new(
    token: '_your_user_token_'
  )
  client = Redbooth::Client.new(session)
```

Now you can perform any user api call inside the clien wrapper

```Ruby
  client.me(:show)
```

If you have multiple applications or you just want to ve explicit use the application credentials inside the session creation

```Ruby
  session = Redbooth::Session.new(
    token: '_your_user_token_',
    consumer_key: '_your_app_key_',
    consumer_secret: '_your_app_secret'
  )
  client = Redbooth::Client.new(session)
```

Copyright (c) 2012-2013 Redbooth. See LICENSE for details.
