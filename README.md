# QualtricsApi

A nice wrapper for the Qualtrics REST API. Currently under fast iterations. 
Full functional, but may see many changes before 1.0 release. 
Not recommended for production use before then.

Just add the gem.

    gem 'qualtrics_api'
    
## Configuration

Set the user, token and default library id

```ruby
Qualtrics.configure do |config|
  config.token = ENV['QUALTRICS_TOKEN']
end
```

Retrieve all survey and messages in Qualtrics
    
```ruby
QualtricsApi::Survey.all   -> returns array of QualtricsApi::Survey objects
```
  
## TODO

  1. Allow retrieving responses in different formats.
  
## Contributing

1. Fork it ( https://github.com/[my-github-username]/qualtrics_api/fork 
2. Add tests.
3. Make your feature addition or bug fix.
4. Send me a pull request.

### Running the test suite

To run the test suite, you will need to configure a `.env` file, following the
example of the `.env.example` file:

    cp .env.example .env

You will need to set the `QUALTRICS_TOKEN` variable needs to be set to the API Token value
associated with your User ID.

Now you can run the tests with:

    rake
