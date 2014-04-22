require "statusboard"

require "net/http"
require "uri"
require "json"

diy_test1 = Statusboard::DIYWidget.new do
	content "TestTest\n\n"
end

puts diy_test1.render

diy_test2 = Statusboard::DIYWidget.new do
	content do
		"I'm loaded lazily."
	end
end

puts diy_test2.render

diy_test3 = Statusboard::DIYWidget.new do
	content Proc.new { "I'm loaded lazily, too." }
end

puts diy_test3.render

bitminter_data = Proc.new do
	uri = URI.parse("https://bitminter.com/api/pool/blocks")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	request = Net::HTTP::Get.new(uri.path)
	response = http.request(request)
	parsed = JSON.parse(response.body)

	parsed.each do |block|
		row do
			cell { content block["height"] }
			cell { content block["confirmations_left"].to_s + " left" }
			cell { content block["generator"] }
			cell { content block["duration"].to_s }
			cell do
				type :percentage
				percentage 50
			end
		end
	end
end

table_test1 = Statusboard::TableWidget.new do
	data bitminter_data
end

puts table_test1.render

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