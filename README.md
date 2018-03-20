[![Build Status](https://travis-ci.org/redbooth/redbooth-ruby.svg?branch=master)](https://travis-ci.org/redbooth/redbooth-ruby)

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

*[Redbooth oauth2 API documentation](https://redbooth.com/api/authentication/)*

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

Refresh Token
------

By default, your access token will expires in 7200 seconds (2 hours). If you want to automatically get a new one, just need to provide the ```refresh_token``` param

```Ruby
session = RedboothRuby::Session.new(
  token: '_your_user_token_',
  refresh_token: '_your_user_refresh_token_',
  auto_refresh_token: true
)
```

You can also provide a callback to get the new access token:

```Ruby
session = RedboothRuby::Session.new(
  token: '_your_user_token_',
  refresh_token: '_your_user_refresh_token_',
  auto_refresh_token: true,
  on_token_refresh: Proc.new do |old_access_token, new_access_token|
    auth = Authentication.where(access_token: old_access_token.token).first
    auth.access_token = new_access_token.token
    auth.refresh_token = new_access_token.refresh_token
    auth.save
  end
)
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

Fetch a specific user

```Ruby
user = client.user(:show, id: 123)
```

TaskLists
=====

Lists task lists in your visibility scope

```Ruby
tasklists_collection = client.task_list(:index)
tasklists = tasklists_collection.all
```

You can also filter by multiple params (see docs [here](https://redbooth.com/api/api-docs/#page:tasklists,header:tasklists-tasklist-list) )

```Ruby
filtered_tasklists = client.task_list(:index, order: 'id-DESC',
                                              per_page: 50,
                                              project_id: 123)
```

Fetch a specific tasklist

```Ruby
tasklist = client.task_list(:show, id: 123)
```

Update a specific tasklist

```Ruby
tasklist = client.task_list(:update, id: 123, name: 'new name')
```

Delete a specific tasklist

```Ruby
client.task_list(:delete, id: 123)
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

Fetch a specific task

```Ruby
task = client.task(:show, id: 123)
```

Update a specific task

```Ruby
task = client.task(:update, id: 123, name: 'new name')
```

Delete a specific task

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

Fetch a specific organization

```Ruby
organization = client.organization(:show, id: 123)
```

Create a organization

```Ruby
organization = client.organization(:create, name: 'New Organization')
```

Update a specific organization

```Ruby
organization = client.organization(:update, id: 123, name: 'new name')
```

Delete a specific organization

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
filtered_projects = client.project(:index, order: 'id-DESC', per_page: 50)
```

Fetch a specific project

```Ruby
project = client.project(:show, id: 123)
```

Create a project

```Ruby
project = client.project(:create, name: 'New Project')
```

Update a specific project

```Ruby
project = client.project(:update, id: 123, name: 'new name')
```

Delete a specific project

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
filtered_people = client.person(:index, order: 'id-DESC', per_page: 50)
```

Fetch a specific person

```Ruby
people = client.person(:show, id: 123)
```

Create a person

```Ruby
person = client.person(:create, project_id: 123, user_id: 123, role: 'participant')
```

Update a specific person

```Ruby
person = client.person(:update, id: 123, role: 'admin')
```

Delete a specific person

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
filtered_memberships = client.membership(:index, order: 'id-DESC', per_page: 50)
```

Fetch a specific membership

```Ruby
memberships = client.membership(:show, id: 123)
```

Create a membership

```Ruby
membership = client.membership(:create, organization_id: 123, user_id: 123,
  role: 'participant')
```

Update a specific membership

```Ruby
membership = client.membership(:update, id: 123, role: 'admin')
```

Delete a specific membership

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

Fetch a specific conversation

```Ruby
conversation = client.conversation(:show, id: 123)
```

Update a specific conversation

```Ruby
conversation = client.conversation(:update, id: 123, name: 'new name')
```

Delete a specific conversation

```Ruby
client.conversation(:delete, id: 123)
```

Comments
=====

Comments are the redbooth resources containing the `Task` and `Conversation` Content.
It also contains the information about the task status changes, assigned changes and due_data changes.

To consume the comments endpoint you allways need to provide a `target_type` and `target_id`. This is needed for performance reasons.

Lists comments in your visibility scope

```Ruby
comment_collection = client.comment(:index, target_type: 'task', target_id: 123)
comments = comment_collection.all
```

You can also filter by multiple params (see docs [here](https://redbooth.com/api/api-docs/#page:comments,header:comments-commnets-list) )

```Ruby
filtered_comments = client.comment(:index, order: 'id-DESC',
                                           per_page: 50,
                                           project_id: 123,
                                           target_type: 'task',
                                           target_id: 123)
```

Fetch a specific comment

```Ruby
comment = client.comment(:show, id: 123)
```

Update a specific comment

```Ruby
comment = client.comment(:update, id: 123, body: 'new body content')
```

Delete a specific comment

```Ruby
client.comment(:delete, id: 123)
```

Notes
=====

Lists notes in your visibility scope

```Ruby
notes_collection = client.note(:index)
notes = notes_collection.all
```

You can also filter by multiple params (see docs [here](https://redbooth.com/api/api-docs/#page:notes,header:notes-notes-list) )

```Ruby
filtered_notes = client.note(:index, order: 'id-DESC',
                                     per_page: 50,
                                     project_id: 123)
```

Fetch a specific note

```Ruby
note = client.note(:show, id: 123)
```

Update a specific note

```Ruby
note = client.note(:update, id: 123, name: 'new name')
```

Delete a specific note

```Ruby
client.note(:delete, id: 123)
```

Subtasks
=====

Subtasks are little sentences under a task that could de resolved or not.

Lists subtasks in your visibility scope. Needs a task_id

```Ruby
subtask_collection = client.subtask(:index, task_id: 123)
subtasks = subtask_collection.all
```

You can also filter by multiple params (see docs [here](https://redbooth.com/api/api-docs/#page:subtasks,header:subtasks-subtasks-list) )

```Ruby
filtered_subtasks = client.subtask(:index, task_id: 123,
                                           order: 'id-DESC',
                                           per_page: 50)
```

Fetch a specific subtask

```Ruby
subtask = client.subtask(:show, id: 123)
```

Create a new subtask

```Ruby
subtask = client.subtask(:create, task_id: 123, name: 'new name')
```

Update a specific subtask

```Ruby
subtask = client.subtask(:update, id: 123, name: 'new name')
```

Delete a specific subtask

```Ruby
client.subtask(:delete, id: 123)
```

Files
=====

Files in redbooth could be uploaded or choosen form other service providers (Copy, Dropbox, Gdrive, Box, Signnow, ...). This client allows you to browse or create files in redbooth api.

Lists files in your visibility scope.

```Ruby
files_colilection = client.file(:index)
files = files_collection.all
```

You can also filter by multiple params (see docs [here](https://redbooth.com/api/api-docs/#page:subtasks,header:subtasks-subtasks-list) )

```Ruby
filtered_files_collection = client.file(:index, backend: 'redbooth',
                                                project_id: 123,
                                                order: 'id-DESC',
                                                per_page: 25)
```

Update a specific file

```Ruby
file = client.file(:update, id: 123, name: 'new_name.doc')
```

Create a new file

```Ruby
file = File.open('path/to/the/file')
new_file = client.file(:create, project_id: 123,
                                parent_id: nil,
                                backend: 'redbooth',
                                is_dir: false,
                                asset: file )
```

Delete a specific subtask

```Ruby
client.file(:delete, id: 123)
```

Download a file

```Ruby
file # RedBoothRuby::File

open('/path/to/your_new_file.txt', 'w') { |f| f.puts file.download }
```

Search
=====

You can search throught any redbooth entity by using the search method. There is some filter params available:

* `query`: Regex like query to search

* `project_id`: Reduce the scope to search for

* `target_type`: List of entity types to be returned


Search for redbooth objects in your visibility scope

```Ruby
entities = client.search(query: 'task+nothing*')
```

Metadata
=====

ADVISE: Redbooth metadata API is in `Beta` status so use this under your own risk.

Metadata API allows you to add custo key value attributes to objects inside redbooth and search by those key value attributes.
This is really helpful when doing API syncs or tiny implementations in top of the Redbooth API.

Fetch object metadata

```Ruby
task.metadata
```

Update object metadata by adding new keys or overwriding the exisiting ones but not touching the others if there is any one.

```Ruby
task.metadata_merge("new_key" => "new value")
```

Restore user metadata by overwiritng the existing ones.

```Ruby
task.metadata = {"key" => "value"}
```

Search for a certain metadata key value

```Ruby
metadata_collection = client.metadata(key: 'key', value: 'value', target_type: 'Task')
```

License
=====

Copyright (c) 2012-2013 Redbooth. See LICENSE for details.
