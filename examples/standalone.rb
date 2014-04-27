require "statusboard/main"

# Server listens on port 7777
server_settings :Port => 7777

# Specify a graph that plots the f(x)=x function
widget "yequalsx", :graph do

	# Configure basic settings of the graph
	title "My first graph"
	type :line

	# Specify the "data source" - in this case a block. (alternative: a proc)
	data do
		# One graph can have multiple data sequences (which translates to multiple lines/bar colors), we define one
		data_sequence do
			title "f(x) = x"

			# The data sequence consists of 16 datapoints which represent the function f(x)=x from 0 to 15
			(0..15).each do |n|
				datapoint n, n
			end
		end
	end
end

# Specify a table widget which contains the values of the function f(x) from 0 tp 15 (as plotted in the graph widget)
widget "yequalsxtable", :table do

	# We specify the data as a block
	data do

		# Table header
		row do
			cell do
				type :text
				content "x"
			end
			cell do
				type :text
				content "f(x)"
			end
		end

		# Add a row for each value to the table
		(0..15).each do |n|
			row do
				cell do
					type :text
					content n
				end
				cell do
					type :text
					content n
				end
			end
		end
	end
end