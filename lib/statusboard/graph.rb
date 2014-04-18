module Statusboard

	class GraphWidget < WidgetBase
		def initialize(title, type = :bar)
			@title = title
			@type = type
			@refresh_interval = 120
			@display_totals = false
			@data_sequences = []
		end

		attr_accessor :title, :type, :refresh_interval

		def add_datasequence(title)
			sequence = DataSequence.new(title)
			@data_sequences << sequence

			yield(sequence) if block_given?

			sequence
		end

		def render
		{
			"graph" => {
				"title" 				=> @title,
				"refreshEveryNSeconds"	=> @refresh_interval,
				"totals"				=> @display_totals,
				"type"					=> @type,
				"datasequences"			=> @data_sequences.map(&:render)
			}
		}
		end
	end

	class DataSequence
		def initialize(title)
			@title = title
			@datapoints = {}
		end

		def add_datapoint(key, value)
			@datapoints[key] = value
		end

		def render
			{
				"title" => @title,
				"datapoints" => @datapoints
			}
		end
	end
end