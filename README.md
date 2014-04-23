# Statusboard

The statusboard gem provides a simple, expressive DSL which can be used to feed your
Status Board with custom data. The DSL handles table, graph and DIY widgets in a way
that renders messing around with the raw data unnecessary. The included Rack module
makes the statusboard gem an all-in-one solution for a Status Board data source by
serving the data to the app without requiring any further configuration or code.
The kind of data which is served is only limited by your mind as the DSL is 100%
pure ruby. You can use all the functions and gems you already know to fetch the data
to be served.

## Installation

Add this line to your application's Gemfile:

    gem 'statusboard'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install statusboard

## Usage

The gem can be used in three different ways:

- Standalone
In this scenario, the gem (including the Rack module) is used to create a standalone server
application whose only purpose is to serve the status board data.

- As a module within an existing Rack-based app
In this scenario, the gem (including the Rack module) is used with an existing server application.
The included Rack module is mounted in the application (e.g. using the routes.rb file of a rails
app).

- Without a server
The gem can be used to describe a widget and construct the Status Board compatible ouput. This allows
for an easy integration into existing applications as well as the creation of static status board data
which can be served using an existing webserver like nginx or Apache or using Dropbox.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/statusboard/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
