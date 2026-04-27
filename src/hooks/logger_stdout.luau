local logger_hooks = require("../logger_hooks")

local logger_stdout: logger_hooks.Hook = {
	on_log = function(severity: string, message: string)
		print(`[{string.upper(severity)}]: {message}`)
	end,
}

return logger_stdout
