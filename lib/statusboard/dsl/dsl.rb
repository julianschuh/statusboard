require "statusboard/dsl/base"

module Statusboard
	# Module whoch contains the definition of the DSL that is used to
	# describe and configure the widgets and teir data(sources).
	module DSL
		class ServerDescription < DSLBase

			attr_reader :widgets, :server_settings

			def initialize(&block)
				@widgets = {}

				@server_settings = {
					:Port => 8080,
					:Host => "0.0.0.0"
				}

				super &block unless block.nil?
			end

			def server_settings(settings={})
				@server_settings.merge!(settings)
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
		end

		class GraphDescription < DSLBase

			setter :refresh_interval, :title, :type
			setter_with_default_value :display_totals, true

			def data(proc = nil, &block)
				@data = if proc.nil? then block else proc end
			end

			def x_axis(&block)
				@x_axis = XAxis.new(&block)
			end

			def y_axis(&block)
				@y_axis = YAxis.new(&block)
			end

			def construct
				constructed = {
					"graph" => {
						"title" 				=> @title,
						"refreshEveryNSeconds"	=> @refresh_interval,
						"totals"				=> @display_totals,
						"type"					=> @type
					}
				}

				begin
					data = GraphData.new(&@data)
					constructed["graph"]["datasequences"] = data.construct
				rescue DataSourceError => e
					constructed["graph"]["error"] = {
						"message" => e.message,
						"detail" => e.message
					}
				end

				constructed["graph"]["xAxis"] = @x_axis.construct unless @x_axis.nil?
				constructed["graph"]["yAxis"] = @y_axis.construct unless @y_axis.nil?
				
				constructed
			end

			protected

			class XAxis < DSLBase
				setter_with_default_value :show_every_label, true

				def construct
					{
						"showEveryLabel" => @show_every_label
					}
				end
			end

			class YAxis < DSLBase

				setter :min_value, :max_value, :units_suffix, :units_prefix, :scale_to
				setter_with_default_value :hide_labels, true

				def construct
					constructed = {
						"scaleTo" => @scale_to,
						"hide" => @hide_labels,
						"units" => { }
					}

					constructed["minValue"] = @min_value unless @min_value.nil?
					constructed["maxValue"] = @max_value unless @max_value.nil?
					constructed["units"]["prefix"] = @units_prefix unless @units_prefix.nil?
					constructed["units"]["suffix"] = @units_suffix unless @units_suffix.nil?

					constructed
				end
			end

			class GraphData < DSLBase
				def initialize(&block)
					@data_sequences = []

					super &block
				end

				def data_sequence(title = nil, &block)
					@data_sequences << DataSequence.new(title, &block)
				end

				def construct
					@data_sequences.map(&:construct)
				end
			end

			class DataSequence < DSLBase
				def initialize(title, &block)
					@datapoints = []
					@title = title

					super &block
				end

				setter :title, :color

				def datapoint(x, y)
					@datapoints << {title: x.to_s, value: y.to_s}
				end

	            def construct
	                constructed = {
	                    "title" => @title,
	                    "datapoints" => @datapoints
	                }
	                constructed["color"] = @color unless @color.nil?

	                constructed
	            end
			end
		end

		class DiyDescription < DSLBase
			def content(proc_or_content = nil, &block)
				@content = if proc_or_content.nil? then block else proc_or_content end
			end

			def construct
				content = if @content.respond_to?(:call) then @content.call() else @content end

				{
					content: content
				}
			end
		end

		class TableDescription < DSLBase
			def data(proc = nil, &block)
				@data = if proc.nil? then block else proc end
			end

			def construct
				data = TableData.new(&@data).construct

				{
					data: data
				}
			end

			protected

			class TableData < DSLBase
				def initialize(&block)
					@rows = []

					super &block
				end

				def row(&block)
					@rows << TableRow.new(&block)
				end

				def construct
					{
						rows: @rows.map(&:construct)
					}
				end
			end

			class TableRow < DSLBase
				def initialize(&block)
					@cells = []

					super &block
				end

				def cell(type = :text, &block)
					@cells << TableCell.new(type, &block)
				end

				def construct
					{
						cells: @cells.map(&:construct)
					}
				end
			end

			class TableCell < DSLBase
				setter :content, :colspan, :width, :percentage, :imageurl, :type
				setter_with_default_value :noresize, true

				def initialize(type, &block)

					@type = :text
					@type = type unless type.nil?

					@noresize = false

					super &block
				end

				def construct
					{
						content: @content,
						type: @type,
						width: @width,
						percentage: @percentage,
						imageurl: @imageurl,
						noresize: @noresize
					}
				end
			end
		end
	end
end