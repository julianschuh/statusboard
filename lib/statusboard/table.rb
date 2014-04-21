module Statusboard
	# Class which represents table widgets for Status Board.
	# The widget is configured and filled with data using a DSL
	# which is passed to the constructor.
	class TableWidget < WidgetBase

		def initialize(&block)
			@table_description = DSL::TableDescription.new(&block)
		end

		def render
			table_data = @table_description.construct

			result = ""

			table_data[:data][:rows].each do |row|
				result << "<tr>"

				row[:cells].each do |cell|
					result << "<td>"
					result << cell[:content].to_s
					result << "</td>"
				end

				result << "</tr>"
			end

			result
		end
	end
end