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

Users
=====

List users in your network

```Ruby
  users = client.user(:index)
```

Fetch a especific user

```Ruby
  user = client.user(:show, id: 123)
```

Tasks
=====

Lists tasks in your visibility scope

```Ruby
  tasks = client.task(:index)
```

You can also filter by multiple params (see docs [here](https://redbooth.com/api/api-docs/#page:tasks,header:tasks-task-list) )

```Ruby
  filtered_tasks = client.task(:index, order: 'id-DESC',
                                        per_page: 50,
                                        project_id: 123)
```

Fetch a especific task

```Ruby
  task = client.task(:show, id: 123)
```

Update a especific task

```Ruby
  task = client.task(:update, id: 123, name: 'new name')
```

Delete a especific task

```Ruby
  client.task(:delete, id: 123)
```

Copyright (c) 2012-2013 Redbooth. See LICENSE for details.
