local logger_hooks = require("../logger_hooks")

local logger_fatalerror: logger_hooks.Hook = {
	log_error = error,
}

return logger_fatalerror
