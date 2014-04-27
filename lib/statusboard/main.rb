require "statusboard"

require "rack/handler"
require "rack-handlers"

app = Statusboard::StatusboardServer.new!

Sinatra::Delegator.target = app
Sinatra::Delegator.delegate :widget

# include would include the module in Object
# extend only extends the `main` object
extend Sinatra::Delegator

class Rack::Builder
  include Sinatra::Delegator
end

at_exit { Rack::Handler.default.run app }