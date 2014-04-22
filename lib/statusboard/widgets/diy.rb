module Statusboard
	# Class which represents DIY widgets for Status Board.
	# The widget is configured and filled with data using a DSL
	# which is passed to the constructor.
	class DIYWidget < WidgetBase

		def initialize(&block)
			@diy_description = DSL::DIYDescription.new(&block)
		end

		def render
			@diy_description.construct[:content]
		end
	end
end