require "json"

module Statusboard
	class GraphWidget < WidgetBase
		def initialize(&block)
			@graph_description = DSL::GraphDescription.new(&block)
		end

		def render
			@graph_description.construct.to_json
		end
	end
end