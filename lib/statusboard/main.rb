require "statusboard"
require "statusboard/server"

require "rack/handler"
require "rack-handlers"

app = Statusboard::StatusboardServer.new! # create a new, _unwrapped_ instance of the server class

# Make the top-level syntax work by delegating the right function calls to the right destination
Sinatra::Delegator.target = app
Sinatra::Delegator.delegate :widget, :server_settings

# include would include the module in Object
# extend only extends the main object
extend Sinatra::Delegator

class Rack::Builder
  include Sinatra::Delegator
end

# Run the app _after_ the applications main file (where this file was included in) was executed successfully to allow for configuration
at_exit { Rack::Handler.default.run(app, app.server_settings) if $!.nil? }