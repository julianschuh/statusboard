require "sinatra/base"

module Statusboard

	# Simple Sinatra-based server whose task it is to serve widgets to the app(s)
	# using http. Widgets can be defined directly using the DSL or by passing already
	# initialized Widget-objects. The widgets are identified using a unique name for
	# each defined widget.
	class StatusboardServer < Sinatra::Base

		attr_reader :server_description

		# Initializes a new instance of the server using the configuration specified via
		# the DSL in the block. The server will be initialized without any widgets if no
		# block is specified.
		def initialize(*args, &block)

			super(*args, &nil)	# Dont pass the block to super as it would result in errors because the dsl methods aren't available if not instance_eval'd

			@server_description = DSL::ServerDescription.new &block
		end

		get "/widget/:name/?" do |widget|
			raise Sinatra::NotFound if @server_description.widgets[widget.to_sym].nil?

			@server_description.widgets[widget.to_sym].render
		end
	end
end