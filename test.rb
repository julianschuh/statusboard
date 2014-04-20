require "statusboard"

supply = Proc.new do
	data_sequence do
		title "Fucking"

		(0..59).step(5) do |n|
			datapoint "10:" + n.to_s, 17
		end
	end
	
	data_sequence do
		title "Fucking 2"
		color "blue"

		(0..59).step(5) do |n|
			datapoint "10:" + n.to_s, 26
		end
	end
end

x = Statusboard::GraphWidget.new do

	title "Test"
	type :line
	refresh_interval 30
	display_totals

	x_axis do
		show_every_label
	end

	y_axis do
		min_value 1
		max_value 24
		units_suffix "€"
		scale_to 1
		hide_labels
	end

	data supply
end

puts x.render