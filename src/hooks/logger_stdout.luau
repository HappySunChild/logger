local logger_hooks = require("../logger_hooks")

local logger_stdout: logger_hooks.Hook = {
	log = function(message: string)
		print(message)
	end,
	log_warning = function(message: string)
		print(`\x1b[93m{message}\x1b[0m`)
	end,
	log_error = function(message: string)
		print(`\x1b[91m{message}\x1b[0m`)
	end,
}

return logger_stdout
