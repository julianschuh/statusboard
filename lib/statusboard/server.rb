require "statusboard"
require "sinatra/base"

module Statusboard

	# Simple Sinatra-based server which serves widgets to the app using http.
	# The Widgets can be defined using a simple DSL either using the block of
	# the constructor or alternatively as first-level statements when main
	# is included.
	class StatusboardServer < Sinatra::Base

		def initialize(*args, &block)

			@widgets = {}

			super(*args, &nil)	# Dont pass the block to super as it would result in errors because the dsl methods aren't available if not instance_eval'd

			instance_eval &block unless block.nil?
		end

		def widget(name, type_or_widget, &block)
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

		get "/widget/:name/?" do |widget|
			raise Sinatra::NotFound if @widgets[widget.to_sym].nil?

			@widgets[widget.to_sym].render
		end
	end
end