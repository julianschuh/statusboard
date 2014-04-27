require "statusboard"
require "sinatra/base"

module Statusboard

	# Simple Sinatra-based server whose task it is to serve widgets to the app(s)
	# using http. Widgets can be defined directly using the DSL or by passing already
	# initialized Widget-objects. The widgets are identified using a unique name for
	# each defined widget.
	class StatusboardServer < Sinatra::Base

		# Initializes a new instance of the server using the configuration specified via
		# the DSL in the block. The server will be initialized without any widgets if no
		# block is specified.
		def initialize(*args, &block)
			@widgets = {}
			@server_settings = {
				:Port => 8080,
				:Host => "0.0.0.0"
			}

			super(*args, &nil)	# Dont pass the block to super as it would result in errors because the dsl methods aren't available if not instance_eval'd

			instance_eval &block unless block.nil?
		end

		# Registers a new widget which will be served by the server.
		#
		# ==== Attributes
		#
		# * +name+ - Unique identifier of the widget. The widget will be accessible using the URL /widget/+name+
		# * +type_or_widget+ - Either the type of the widget as a symbol (:table, :graph, :diy) or an already initialized widget object
		# * +&block+ - If only the type of the widget was specified in the previous paremeter, the block must be specified and contain the DSL statements which descibe the widget
		def widget(name, type_or_widget, &block)
			raise ArgumentError, "Widget name " + name.to_s + " already taken" unless @widgets[name.to_sym].nil?

			if type_or_widget.respond_to?(:render)
				@widgets[name.to_sym] = type_or_widget
			else
				raise ArgumentError, "Widget " + name.to_s + " specified without block." if block.nil?

				begin
					klass = Statusboard.const_get(type_or_widget.to_s.capitalize + "Widget")
				rescue NameError
					raise ArgumentError, "Invalid widget type " + type_or_widget.to_s + " specified."
				end

				@widgets[name.to_sym] = klass.new(&block)
			end
		end

		def server_settings(settings={})
			@server_settings.merge!(settings)
		end

		get "/widget/:name/?" do |widget|
			raise Sinatra::NotFound if @widgets[widget.to_sym].nil?

			@widgets[widget.to_sym].render
		end
	end
end