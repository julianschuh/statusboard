module Statusboard
	module DSL
		class DSLBase
			# Automatically creates DSL-like setters for the specified fields.
			# Fields should be specified as symbols.
			def self.setter(*method_names)
				method_names.each do |name|
					send :define_method, name do |data|
						instance_variable_set "@#{name}".to_sym, data 
					end
				end
			end

			# Automatically creates a DSL-like setter with a specified default value
			# (so the setter can be called without an argument) for a specified field.
			# Field should be specified as symbol. The default value is ONLY used if the
			# method is called without parameters. If a default value is needed for the
			# case that the method is not called at all by the user, the default value
			# must be specified manuelly in the constructor.
			def self.setter_with_default_value(method_name, default_value)
				send :define_method, method_name do |data = default_value|
					instance_variable_set "@#{method_name}".to_sym, data 
				end
			end

			def initialize(&block)
				instance_eval &block
			end
		end
	end
end