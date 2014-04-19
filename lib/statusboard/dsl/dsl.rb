module Statusboard
	module DSL
		class GraphDescription
			def initialize(&block)
				@refresh_interval = 120
				@display_totals = false
				@data_sequences = []
				@title = ""
				@type = :bar
				@x_axis = nil
				@y_axis = nil

				instance_eval &block
			end

			def refresh_interval(refresh_interval)
				@refresh_interval = refresh_interval
			end

			def display_totals(display = true)
				@display_totals = display
			end

			def data_sequence(&block)
				@data_sequences << DataSequence.new(&block)
			end

			def title(title)
				@title = title
			end

			def type(type)
				@type = type.to_sym
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
						"type"					=> @type,
						"datasequences"         => @data_sequences.map(&:construct)
					}
				}

				constructed["graph"]["xAxis"] = @x_axis.construct unless @x_axis.nil?
				constructed["graph"]["yAxis"] = @y_axis.construct unless @y_axis.nil?
				
				constructed
			end
		end

		class XAxis
			def initialize(&block)
				@show_every_label = false

				instance_eval &block
			end

			def show_every_label(show = true)
				@show_every_label = show
			end

			def construct
				{
					"showEveryLabel" => @show_every_label
				}
			end
		end

		class YAxis
			def initialize(&block)
				@min_value = nil
				@max_value = nil
				@units_prefix = nil
				@units_suffix = nil
				@scale_to = 1
				@hide_labels = false

				instance_eval &block
			end

			def min_value(min)
				@min_value = min
			end

			def max_value(max)
				@max_value = max
			end

			def units_suffix(suf)
				@units_suffix = suf
			end

			def units_prefix(pre)
				@units_prefix = pre
			end

			def scale_to(scale)
				@scale_to = scale
			end

			def hide_labels(hide = true)
				@hide_labels = hide
			end

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

		class DataSequence
			def initialize(&block)
				@name = ""
				@datapoints = []
				@color = nil

				instance_eval &block
			end

			def name(name)
				@name = name
			end

			def datapoint(x, y)
				@datapoints << {key: x, value: y}
			end

			def color(color)
				@color = color
			end

            def construct
                constructed = {
                    "title" => @title,
                    "datapoints" => @datapoints
                }
                construct["color"] = @color unless @color.nil?

                constructed
            end
		end
	end
end