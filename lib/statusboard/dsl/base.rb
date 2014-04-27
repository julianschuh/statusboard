module Statusboard
	module DSL
		class DSLBase

			# Automatically creates DSL-like setters for the specified fields.
			# Fields must be specified as symbols.
			def self.setter(*method_names)
				method_names.each do |name|
					send :define_method, name do |data|
						instance_variable_set "@#{name}".to_sym, data 
					end
				end
			end

			# Automatically creates a DSL-like setter for a specified field. If
			# the setter is called by the *user without an argument*, the specified
			# default value will be used as the value.
			#
			# The method will _NOT_ use the specified value as a default value for
			# the field. If a default value is needed, the field should be set in
			# the constructor.
			#
			# ==== Attributes
			#
			# * +method_name+ - Name of the field for which a setter should be created
			# * +default_value+ - Default value of the argument which is used if the method is called without an argument
			def self.setter_with_default_value(method_name, default_value)
				send :define_method, method_name do |data = default_value|
					instance_variable_set "@#{method_name}".to_sym, data 
				end
			end

			# Default constructor. Executes the given block within its own context, so the block
			# contents behave as a DSL.
			def initialize(&block)
				instance_eval &block
			end
		end
	end
end