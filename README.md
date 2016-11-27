# FileDb

You need to store data into a small type of database, like CSV and want a better way to handle it? So you can use `FileDb` for this. It stores all data for a model into CSV files and create accessor for you.

## Installation

hm, yeah. just add this to your Gemfile:

```ruby
gem 'file_db', '~> 0.7.0'
```

And then execute:
```
  $ bundle
```
Or install it yourself as:
```
  $ gem install file_db
```

Huh, ready to use!

## Usage

### Configuration

First configure the storage directory:

```ruby
FileDb::Configuration.configure data_directory: 'data'
```
Subdirectory is the default for storing the tables. If you change the configuration, the `FileDb` will be automaticly create a new database.

If you running a clean instance with no configuration changes so make sure, the storage directory exists or use the build in check for checking and creating the data directory:
```ruby
FileDb::System::Check.run!
```

Let's start with creating a model called `User`.

```ruby
class User < FileDb::Model

end
```

Now we got a user model which actually just storing an id. lets add some `columns` for this.

```ruby
class User < FileDb::Model
  columns :name, :email
end
```

Now lets create some entries.

```ruby
my_user = User.new name: 'rob'
my_user.save
```
now the `User` is stored under `data/user.csv`. You should find an entry like this one:

```
1,rob,
```

You can also use `create` to create it directly without calling save:


```ruby
my_user = User.create name: 'rob'
```

Let's get them user back:
```ruby
User.find 1
-> #<User:0x00000004651798 @name="rob", @id="1", @email=nil>
```

you can access all attributes like `attr_accessor`

```ruby
User.find(1).name
-> rob
```

The accessors will be created automaticly for you.
Let's find all users named with rob. I think you know how get this to work:

```ruby
User.where(name: 'rob')
-> [#<User:0x00000004651798 @name="rob", @id="1", @email=nil>]
```

It's also fine to search with more than one parameter.

```ruby
User.where(name: 'rob', email: nil)
-> [#<User:0x00000004651798 @name="rob", @id="1", @email=nil>]
```

For the first User with name rob you can use:

```ruby
User.where(name: 'rob', email: nil).first
-> #<User:0x00000004651798 @name="rob", @id="1", @email=nil>
```

or

```ruby
User.find_by(:name, 'rob')
-> [#<User:0x00000004651798 @name="rob", @id="1", @email=nil>]
```


You can also use `first` and `last` to get the first and last user
```ruby
User.first
-> #<User:0x00000004651798 @name="rob", @id="1", @email=nil>
```

```ruby
User.last
-> #<User:0x00000004651798 @name="rob", @id="1", @email=nil>
```

Or you use `all` to get really all users.

```ruby
User.all
-> [#<User:0x00000004651798 @name="rob", @id="1", @email=nil>]
```

rename the user:

```ruby
user = User.find(1)
-> #<User:0x00000004651798 @name="rob", @id="1", @email=nil>
user.name = 'bob'
user.email = 'test@example.com'
user.save
User.find(1)
-> #<User:0x00000004651798 @name="bob", @id="1", @email=test@example.com>
```

delete a record:

```ruby
user = User.find(1)
-> #<User:0x00000004651798 @name="rob", @id="1", @email=nil>
user.delete
User.find(1)
-> nil
```


You want to use another table than `user`? So just configure it:

```ruby
class User < FileDb::Model
  columns :name, :email
  set_table_name 'crazy'
end
```

## The MIT License (MIT)

Copyright (c) 2015  [Robert Starke](robertst81+github@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## Questions?

If you have further questions, code smells, hints or a beer, just contact me :)
