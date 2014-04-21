require "statusboard/dsl/base"

module Statusboard
	# Module whoch contains the definition of the DSL that is used to
	# describe and configure the widgets and teir data(sources).
	module DSL
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
				rescue Exception => e
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

				def data_sequence(&block)
					@data_sequences << DataSequence.new(&block)
				end

				def construct
					@data_sequences.map(&:construct)
				end
			end

			class DataSequence < DSLBase
				def initialize(&block)
					@datapoints = []

					super &block
				end

				setter :title, :color

				def datapoint(x, y)
					@datapoints << {title: x, value: y}
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

		class DIYDescription < DSLBase
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

				def cell(&block)
					@cells << TableCell.new(&block)
				end

				def construct
					{
						cells: @cells.map(&:construct)
					}
				end
			end

			class TableCell < DSLBase
				setter :content, :colspan, :width, :height, :percentage, :imageurl, :type

				def initialize(&block)
					@type = :text

					super &block
				end

				def construct
					{
						content: @content,
						type: @type,
						colspan: @colspan,
						width: @width,
						height: @height,
						percentage: @percentage,
						imageurl: @imageurl
					}
				end
			end
		end
	end
end