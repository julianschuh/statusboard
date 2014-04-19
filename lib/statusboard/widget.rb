module Statusboard

	# (Abstract) class that represents a status board widget.
	# The class must be subclassed for each widget type supported.
	class WidgetBase

		# Method that renders the widget into a format understandable by
		# the status board app depending on the configured/fetched data.
		def render
			raise "Not implemented."
		end
	end
end