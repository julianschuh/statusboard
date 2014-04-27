require "statusboard/widget"

module Statusboard

	# Represents do-it-yourself (DIY) widgets. The widget is configured and
	# filled with data using a DSL which must be passed to the constructor.
	class DiyWidget < WidgetBase

		def initialize(&block)
			@diy_description = DSL::DiyDescription.new(&block)
		end

		def render
			@diy_description.construct[:content]
		end
	end
end