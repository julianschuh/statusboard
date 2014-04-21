require "statusboard/version"
require "statusboard/dsl/dsl"
require "statusboard/widget"
require "statusboard/graph"
require "statusboard/diy"
require "statusboard/table"

module Statusboard
	VIEW_PATH = File.join(File.dirname(__FILE__), "statusboard", "views")
end
