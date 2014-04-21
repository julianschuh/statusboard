require "erb"
require "tilt/erb"

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

			rows = ""
			table_data[:data][:rows].each do |row|

				cells = ""
				row[:cells].each do |cell|
					cells << self.render_template(cell[:type].to_s + "_cell.erb", cell)
				end

				rows << self.render_template("row.erb", cells: cells)
			end

			self.render_template("table.erb", rows: rows)
		end
	end
end