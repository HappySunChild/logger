local logger_hooks = require("../logger_hooks")
local parse_error = require("../parse_error")

local logger_details: logger_hooks.Hook = {
	append_annotations = function(add_annotation: (string) -> (), _, err: parse_error.Error)
		if err == nil then
			return
		end

		add_annotation(`\n\t---- Error message ----\n\t{err.message}\n\n\t---- Stack trace ----\n\t{err.trace}`)
	end,
}

return logger_details
