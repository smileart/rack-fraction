# 🎰 Rack::Fraction

> Middleware which lets you to execute arbitrary code just for a certain fraction of requests

Possible usecases could be: purging cache from time to time, doing A/B test for a fraction of users/reqests, probing something from the request, etc.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-fraction'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-fraction

## Usage

The usage if fairly trivial: you disable the middleware or either modifiy the env or request:

```ruby
# To disable middleware: pass 'modify: nil' (default)
Rack::Fraction.new(app, modify: nil) do |_|
	# disabled middleware
end

# To modify env: pass 'modify: :env'
Rack::Fraction.new(app, modify: :env, percent: 100) do |env|
  # middleware modifies env for 100% requests
  env << '👋'
end

# To modify response: pass 'modify: : response'
Rack::Fraction.new(app, modify: :response, percent: 50) do |*response|
  # middleware modifies response for 50% requests
  response = response.dup
  response.last << 'Bonjour!'
  response
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/smileart/rack-fraction. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rack::Fraction project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/smileart/rack-fraction/blob/master/CODE_OF_CONDUCT.md).
