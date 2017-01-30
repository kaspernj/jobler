# Jobler

Jobler helps you generate large reports or very large and slow pages through background jobs.

## Install

Add it to your Gemfile and bundle it:

```ruby
gem "jobler"
```

Install the migrations and run them:
```bash
rake railties:install:migrations
rake db:migrate
```

Add it to your routes:

```ruby
mount Jobler::Engine => "/jobler"
```

Autoload the "Joblers" you are going to write through application.rb:

```ruby
config.autoload_paths << Rails.root.join("app", "joblers")
```

Add a ApplicationJobler to follow the ApplicationController and ApplicationRecord pattern:
```ruby
class ApplicationJobler < Jobler::BaseJobler
end
```

Jobler is going to queue its jobs through the ActiveJob queue called `:jobler`, so make sure a worker is listening to that queue.

## Usage

Write a new Jobler located in "app/joblers":

```ruby
class MyJobler < ApplicationJobler
  def execute!
    # Do some heavy lifting code wise...
  end
end
```

## License

This project rocks and uses MIT-LICENSE.
