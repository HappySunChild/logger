local logger_hooks = require("../logger_hooks")
local parse_error = require("../parse_error")

local logger_details: logger_hooks.Hook = {
	append_annotations = function(add_annotation: (string) -> (), _, _, err: parse_error.Error)
		if type(err) ~= "table" then
			return
		end

		add_annotation(
			string.gsub(`\n---- Error message ----\n{err.message}\n\n---- Stack trace ----\n{err.trace}`, "\n", "\n\t")
		)
	end,
}

return logger_details
