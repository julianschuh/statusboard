require "statusboard/version"
require "statusboard/dsl/dsl"
require "statusboard/widget"
require "statusboard/widgets/graph"
require "statusboard/widgets/diy"
require "statusboard/widgets/table"

module Statusboard
	VIEW_PATH = File.join(File.dirname(__FILE__), "statusboard", "views")
end
