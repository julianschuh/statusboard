require "statusboard"

g = Statusboard::GraphWidget.new("Server load", :line)

g.add_datasequence('15 min load') do |seq|
	(0..59).step(5) do |n|
		seq.add_datapoint("10:" + n.to_s, 17)
	end
end

puts g.render