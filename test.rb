require "statusboard"

g = Statusboard::GraphWidget.new("Server load", :line)

g.add_datasequence('seq 1') do |seq|
	seq.add_datapoint(1, 17)
	seq.add_datapoint(2, 12)
	seq.add_datapoint(3, 3)
end

g.add_datasequence('seq 2') do |seq|
	seq.add_datapoint(100, 17)
	seq.add_datapoint(200, 12)
	seq.add_datapoint(300, 3)
end

puts g.render