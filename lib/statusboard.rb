require "statusboard/version"

require "statusboard/errors"

require "statusboard/dsl/dsl"

require "statusboard/widgets/graph"
require "statusboard/widgets/diy"
require "statusboard/widgets/table"

require "statusboard/server"

module Statusboard
	VIEW_PATH = File.join(File.dirname(__FILE__), "statusboard", "views")
end
