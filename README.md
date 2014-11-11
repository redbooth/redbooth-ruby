[![Build Status](https://magnum.travis-ci.com/teambox/redbooth-ruby.svg?token=DytWKainUGNzXxdrekWH&branch=feature/tasks)](https://magnum.travis-ci.com/teambox/redbooth-ruby) [![Code Climate](https://codeclimate.com/repos/5461c4f6e30ba075bc0a0ab0/badges/11031f420440e8a9f525/gpa.svg)](https://codeclimate.com/repos/5461c4f6e30ba075bc0a0ab0/feed) [![Test Coverage](https://codeclimate.com/repos/5461c4f6e30ba075bc0a0ab0/badges/11031f420440e8a9f525/coverage.svg)](https://codeclimate.com/repos/5461c4f6e30ba075bc0a0ab0/feed) [![Inline docs](http://inch-ci.org/github/teambox/redbooth-ruby.svg?branch=master)](http://inch-ci.org/github/teambox/redbooth-ruby)

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
  require 'redbooth-ruby'
```

and set up your app credentials


```Ruby
  RedboothRuby.config do |configuration|
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
  session = RedboothRuby::Session.new(
    token: '_your_user_token_'
  )
  client = RedboothRuby::Client.new(session)
```

Now you can perform any user api call inside the clien wrapper

```Ruby
  client.me(:show)
```

If you have multiple applications or you just want to ve explicit use the application credentials inside the session creation

```Ruby
  session = RedboothRuby::Session.new(
    token: '_your_user_token_',
    consumer_key: '_your_app_key_',
    consumer_secret: '_your_app_secret'
  )
  client = RedboothRuby::Client.new(session)
```

Async Endpoints
======

Redbooth API is ready to transform any endpoint to async performing in order to optimize the API response time. When this happens the response will contain:

* `202` status code

* `Retry-After` header with the time in seconds to wait until retry the same request

To know the real response of this request you just need to perform the same request once the retry-after time passed.

In the client we handle this work for you by waiting and repeating the request if needed, but if you want to perform the retry method in any other way (renqueue the job for instance) you should declare it in the client initialize process:

```Ruby
client = RedboothRuby::Client.new(session, retry: -> { |time|  YourFancyJob.enque_in(time, params) })
```

Collections
======

Index methods always return a `RedboothRuby::Request::Collection` object to handle the pagination and ordering.

ie:
```Ruby
tasks_collection = client.task(:index, project_id: 2)
tasks_collection.class # => RedboothRuby::Request::Collection
tasks = tasks_collection.all

tasks_collection.current_page # => 1
tasks_collection.total_pages # => 7
tasks_collection.per_page # => 30
tasks_collection.count # => 208

next_page_collection = tasks_collection.next_page
next_page_collection.class # => RedboothRuby::Request::Collection

prev_page_collection = tasks_collection.prev_page
prev_page_collection.class # => RedboothRuby::Request::Collection
```

## Collection Methods

* `all` :  `Array` of elements in the current page

* `count` :  `Integer` number of the total elements

* `current_page`: `Integer` current page number (nil if the resource is not paginated)

* `total_pages`: `Integer` total pages number (nil if the resource is not paginated)

* `next_page`: `RedboothRuby::Request::Collection` Collection object pointing to the next page (nil if the resource is not paginated or there is no next page)

* `prev_page`: `RedboothRuby::Request::Collection` Collection object pointing to the prev page (nil if the resource is not paginated or there is no next page)

## Examples

Iterating thought all the pages

```Ruby
tasks_collection = client.task(:index, project_id: 2)
tasks = tasks_collection.all

while task_collection = tasks_collection.next_page do
  tasks << task_collection.all
end

tasks.flatten!
```

Users
=====

List users in your network

```Ruby
  users_collection = client.user(:index)
  users = users_collection.all
```

Fetch a especific user

```Ruby
  user = client.user(:show, id: 123)
```

Tasks
=====

Lists tasks in your visibility scope

```Ruby
  tasks_collection = client.task(:index)
  tasks = tasks_collection.all
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

Organizations
=====

Lists organizations in your visibility scope

```Ruby
  organization_collection = client.organization(:index)
  organizations = organization_collection.all
```

You can also filter by multiple params (see docs [here](https://redbooth.com/api/api-docs/#page:organizations,header:organizations-organization-list) )

```Ruby
  filtered_organizations = client.organization(:index, order: 'id-DESC',
                                                       per_page: 50)
```

Fetch a especific organization

```Ruby
  organization = client.organization(:show, id: 123)
```

Create a organization

```Ruby
  organization = client.organization(:create, name: 'New Organization')
```

Update a especific organization

```Ruby
  organization = client.organization(:update, id: 123, name: 'new name')
```

Delete a especific organization

```Ruby
  client.organization(:delete, id: 123)
```

Projects
=====

Lists projects in your visibility scope

```Ruby
  project_collection = client.project(:index)
  projects = project_collection.all
```

You can also filter by multiple params (see docs [here](https://redbooth.com/api/api-docs/#page:projects,header:projects-project-list) )

```Ruby
  filtered_projects = client.project(:index, order: 'id-DESC',
                                                       per_page: 50)
```

Fetch a especific project

```Ruby
  project = client.project(:show, id: 123)
```

Create a project

```Ruby
  project = client.project(:create, name: 'New Project')
```

Update a especific project

```Ruby
  project = client.project(:update, id: 123, name: 'new name')
```

Delete a especific project

```Ruby
  client.project(:delete, id: 123)
```

People
=====

People is the redbooth relation between projects and users containing the role
information

```
|-------|         |--------|         |---------|
| User  |   ==>   | Person |   ==>   | Project |
|-------|         |--------|         |---------|
                      \
                    {role}
```

Lists People in your visibility scope

```Ruby
  people_collection = client.person(:index)
  people = people_collection.all
```

You can also filter by multiple params (see docs [here](https://redbooth.com/api/api-docs/#page:people,header:people-people-list) )

```Ruby
  filtered_people = client.person(:index, order: 'id-DESC',
                                          per_page: 50)
```

Fetch a especific person

```Ruby
  people = client.person(:show, id: 123)
```

Create a person

```Ruby
  person = client.person(:create, project_id: 123, user_id: 123, role: 'participant')
```

Update a especific person

```Ruby
  person = client.person(:update, id: 123, role: 'admin')
```

Delete a especific person

```Ruby
  client.person(:delete, id: 123)
```

Memberships
=====

Memberships is the redbooth relation between organization and users containing the role information

```
|-------|         |------------|         |--------------|
| User  |   ==>   | Membership |   ==>   | Organization |
|-------|         |------------|         |--------------|
                      \
                    {role}
```

Lists Memberships in your visibility scope

```Ruby
  membership_collection = client.membership(:index)
  memberships = membership_collection.all
```

You can also filter by multiple params (see docs [here](https://redbooth.com/api/api-docs/#page:memberships,header:memberships-memberships-list) )

```Ruby
  filtered_memberships = client.membership(:index, order: 'id-DESC',
                                                   per_page: 50)
```

Fetch a especific membership

```Ruby
  memberships = client.membership(:show, id: 123)
```

Create a membership

```Ruby
  membership = client.membership(:create, organization_id: 123, user_id: 123, role: 'participant')
```

Update a especific membership

```Ruby
  membership = client.membership(:update, id: 123, role: 'admin')
```

Delete a especific membership

```Ruby
  client.membership(:delete, id: 123)
```

Conversations
=====

Lists conversations in your visibility scope

```Ruby
  conversation_collection = client.conversation(:index)
  conversations = conversation_collection.all
```

You can also filter by multiple params (see docs [here](https://redbooth.com/api/api-docs/#page:conversations,header:conversations-conversations-list) )

```Ruby
  filtered_conversations = client.conversation(:index, order: 'id-DESC',
                                                       per_page: 50,
                                                       project_id: 123)
```

Fetch a especific conversation

```Ruby
  conversation = client.conversation(:show, id: 123)
```

Update a especific conversation

```Ruby
  conversation = client.conversation(:update, id: 123, name: 'new name')
```

Delete a especific conversation

```Ruby
  client.conversation(:delete, id: 123)
```

License
=====

Copyright (c) 2012-2013 Redbooth. See LICENSE for details.
