[![Build Status](https://img.shields.io/shippable/56404e3d1895ca447422feda.svg)](https://app.shippable.com/projects/56404e3d1895ca447422feda/builds/latest)

# BestPracticeProject

A bundle of various coverage and analytical tools to help you keep your code clean. The idea is that you only have to bundle this project, run the generate config command and start writing clean code for your project.

- Rubocop
- Rails Best Practices
- SCSS Lint
- CoffeeLint

## In development!

This project is still in early development. Currently generating configs only works for Rubocop and SCSS Lint.

## Install

Add to your Gemfile and bundle:
```ruby
gem "best_practice_project"
```

Also add the linters and cops that you wish to use. These are supported:
```ruby
group :development do
  gem "rubocop", "~> 0.35.0", require: false
  gem "coffeelint", "~> 1.11.0", require: false
  gem "scss_lint", "~> 0.42.2", require: false
  gem "rails_best_practices", "~> 1.15.7", require: false
end
```

Add this to your Rakefile:
```ruby
BestPracticeProject.load_tasks
```

## Usage

First you can generate some todo configs like this:
```bash
bundle exec rake best_practice_project:generate_configs
```

You can then run all the checks like this:
```bash
bundle exec rake best_practice_project:run
```

You can also run each check manually like this:
```bash
bundle exec rake best_practice_project:run_rubocop
bundle exec rake best_practice_project:run_rails_best_practices
bundle exec rake best_practice_project:run_coffee_lint
bundle exec rake best_practice_project:run_scss_lint
```

Rubocop supports auto correct. Use it like this:
```bash
bundle exec rake best_practice_project:run_rubocop --auto-correct
```

Or:
```bash
bundle exec rake best_practice_project:run --auto-correct
```

## Contributing to best_practice_project

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2015 kaspernj. See LICENSE.txt for
further details.

