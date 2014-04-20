module Statusboard
	# Class which represents table widgets for Status Board.
	# The widget is configured and filled with data using a DSL
	# which is passed to the constructor.
	class TableWidget < WidgetBase

		def initialize(&block)
			@table_description = DSL::TableDescription.new(&block)
		end

		def render
			@table_description.construct
		end
	end
end