module Statusboard

	# (Abstract) class that represents a status board widget.
	# The class must be subclassed for each widget type supported.
	class WidgetBase

		# Each widget is initializes using the DSL. When creating the
		# widget, the block containing the DSL statements must be
		# specified so the Widget can be initialized correctly.
		def initialize(&block)
			raise "Not implemented."
		end

		# Method that renders the widget into a format understandable by
		# the status board app depending on the configured/fetched data.
		def render
			raise "Not implemented."
		end
	protected

		def render_template(template, locals = {})
			widget_type = self.class.name.split('::').last.sub(/Widget$/, '').downcase
			Tilt::ERBTemplate.new(File.join(Statusboard::VIEW_PATH, widget_type, template)).render(nil, locals)
		end
	end
end