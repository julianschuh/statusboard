require "sinatra/base"

module Statusboard

	# Simple Sinatra-based server which serves widgets to the app using http.
	# The Widgets can be defined using a simple DSL either using the block of
	# the constructor or alternatively as first-level statements when main
	# is included.
	class StatusboardServer < Sinatra::Base
		def initialize(&block)
			@widgets = {}

			super

			instance_eval &block unless block.nil?
		end

		def widget(name, widget)
			@widgets[name.to_sym] = widget
		end

		get "/widget/:name" do |widget|
			raise Sinatra::NotFound if @widgets[widget.to_sym].nil?

			@widgets[widget.to_sym].render
		end
	end
end