require "json"

module Statusboard
	# Class which represents graph widgets for Status Board.
	# The widget is configured and filled with data using a DSL
	# whoch is passed to the constructor.
	class GraphWidget < WidgetBase

		# Initializes a new graph widget instance using the configuration
		# and data source specified in the block. The block is excepted to
		# use the DSL.
		def initialize(&block)
			@graph_description = DSL::GraphDescription.new(&block)
		end

		def render
			@graph_description.construct.to_json
		end
	end
end