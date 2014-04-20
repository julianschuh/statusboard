module Statusboard
	# Module whoch contains the definition of the DSL that is used to
	# describe and configure the widgets and teir data(sources).
	module DSL
		class DSLBase
			# Automatically creates DSL-like setters for the specified fields.
			# Fields should be specified as symbols.
			def self.setter(*method_names)
				method_names.each do |name|
					send :define_method, name do |data|
						instance_variable_set "@#{name}".to_sym, data 
					end
				end
			end

			# Automatically creates a DSL-like setter with a specified default value
			# (so the setter can be called without an argument) for a specified field.
			# Field should be specified as symbol.
			def self.setter_with_default_value(method_name, default_value)
				send :define_method, method_name do |data = default_value|
					instance_variable_set "@#{method_name}".to_sym, data 
				end
			end
		end

		class GraphDescription < DSLBase
			def initialize(&block)
				@refresh_interval = 120
				@display_totals = false
				@data = nil
				@title = ""
				@type = :bar
				@x_axis = nil
				@y_axis = nil

				instance_eval &block
			end

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
		end

		class GraphData < DSLBase
			def initialize(&block)
				@data_sequences = []

				instance_eval &block
			end

			def data_sequence(&block)
				@data_sequences << DataSequence.new(&block)
			end

			def construct
				@data_sequences.map(&:construct)
			end
		end

		class XAxis < DSLBase
			def initialize(&block)
				@show_every_label = false

				instance_eval &block
			end

			setter_with_default_value :show_every_label, true

			def construct
				{
					"showEveryLabel" => @show_every_label
				}
			end
		end

		class YAxis < DSLBase
			def initialize(&block)
				@min_value = nil
				@max_value = nil
				@units_prefix = nil
				@units_suffix = nil
				@scale_to = 1
				@hide_labels = false

				instance_eval &block
			end

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

		class DataSequence < DSLBase
			def initialize(&block)
				@title = ""
				@datapoints = []
				@color = nil

				instance_eval &block
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
end