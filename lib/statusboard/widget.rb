require "erb"
require "tilt/erb"

module Statusboard

	# (Abstract) class that represents a widget which can be displayed
	# using the Status Board app.
	# The class must be subclassed for each supported widget type.
	class WidgetBase

		# Each widget must be initialized using a DSL. When creating the
		# widget, the block containing the DSL statements must be specified
		# in the constructor.
		def initialize(&block)
			raise "Not implemented."
		end

		# Method that renders the specific widget into a (text-)format understandable
		# by the Status Board app.
		def render
			raise "Not implemented."
		end

	protected
		# Renders a specified template with the specified local variables in the context
		# of the object itself. The method will search for the template in a subdirectory
		# of the gems VIEW_PATH. The subdirectory will be derived from the class name.
		#
		# Example:
		# 			GraphWidget => views/graph/,
		# 			TestWidget => views/test/
		def render_template(template, locals = {})
			widget_type = self.class.name.split('::').last.sub(/Widget$/, '').downcase
			Tilt::ERBTemplate.new(File.join(Statusboard::VIEW_PATH, widget_type, template)).render(self, locals)
		end
	end
end