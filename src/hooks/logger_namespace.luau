local logger_hooks = require("../logger_hooks")

export type Options = {
	namespace: string,
}

local function logger_namespace(options: Options)
	local namespace_hook: logger_hooks.Hook = {
		prepend_annotations = function(add_annotation: (string) -> ())
			add_annotation(`[{options.namespace}]`)
		end,
	}

	return namespace_hook
end

return logger_namespace
