# include would include the module in Object
# extend only extends the `main` object
app = Statusboard::StatusboardServer.new!

Sinatra::Delegator.target = app
Sinatra::Delegator.delegate :widget

extend Sinatra::Delegator

class Rack::Builder
  include Sinatra::Delegator
end