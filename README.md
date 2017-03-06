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
  # This method will be executed in the background
  def execute!
    my_temp_file = Tempfile.new

    # Do some heavy lifting code wise...

    create_result!(name: "my-file", temp_file: my_temp_file)
  end

  # This method will be called from the web when the execute is completed and successful
  def result
    Jobler::FileDownload.new(
      file_name: "some-file.zip",
      temp_file: temp_file_for_result(name: "my-file")
    )
  end
end
```

You can do something like this in your controller:
```ruby
class MyController < Jobler::BaseController
  def some_action
    scheduler = Jobler::JobScheduler.create! jobler_type: "MyJobler", job_args: {
      current_user_id: current_user.id,
      query_parameters: request.query_parameters
    }

    redirect_to jobler.job_path(scheduler.job)
  end
end
```

This will show a wait page and them a complete page with a download link, once the job is completed.


# Rendering views

First add a special controller that your Jobler's can use:

```ruby
class ApplicationJoblerController < ApplicationController
end
```

Then call render from within the execute method:
```ruby
class TestRenderJobler < Jobler::BaseJobler
  def execute!
    create_result!(
      name: "render",
      content: render(:show)
    )
  end

  def result
    Jobler::RedirectTo.new(url: "/jobler_jobs/jobs/#{job.to_param}")
  end
end
```

This will render the view located at "app/joblers/test_render_jobler/show.*"

You should then create a controller something like this:

```ruby
class JoblerJobsController < ApplicationController
  def show
    @job = Jobler::Job.find_by!(slug: param[:id])
    @result = @job.results.find_by!(name: "render")
  end
end
```

And a view in "app/views/jobler_jobs/show.html.erb":
```erb
<%= @result.result.force_encoding("utf-8").html_safe
```

You should also add a route like this:
```ruby
Rails.application.routes.draw do
  resources :jobler_jobs, only: :show
end
```

## License

This project rocks and uses MIT-LICENSE.
