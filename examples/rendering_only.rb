require "statusboard"

# In this example, the Statusboard-compatible output will be generated without any server-related code
# being involved. Could be used to integrate the serving of Statusboard widgets into existing applications.

widget = Statusboard::GraphWidget.new do
	title "My first graph"
	type :line

	data do
		data_sequence do
			title "f(x) = x"

			(0..15).each do |n|
				datapoint n, n
			end
		end
	end
end

puts widget.render