local logger_hooks = require("./logger_hooks")

export type Options = {
	hooks: { logger_hooks.Hook }?,
}
export type ConfiguredLogger = {
	info: (message: string, ...any) -> (),
	warning: (message: string, ...any) -> (),
	error: (message: string, ...any) -> (),
	fatal: (message: string, ...any) -> (),
}

local function get_formatted_message(
	hooks: logger_hooks.LoggerHooks,
	severity: string,
	message: string,
	...: any
): string
	local prepend_annotations = {}
	local append_annotations = {}

	hooks.notify("overwrite_message", function(new_message: string)
		message = new_message
	end, message, severity, ...)

	hooks.notify("prepend_annotations", function(annotation: string)
		table.insert(prepend_annotations, annotation)
	end, message, severity, ...)
	hooks.notify("append_annotations", function(annotation: string)
		table.insert(append_annotations, annotation)
	end, message, severity, ...)

	return `{table.concat(prepend_annotations, " ")} {message} {table.concat(append_annotations, " ")}`
end

local function logger(options: Options): ConfiguredLogger
	local hooks = logger_hooks(options.hooks)

	local function log(severity: string, message: string, ...)
		hooks.notify("on_raw_log", severity, message, ...)
		hooks.notify("on_log", severity, get_formatted_message(hooks, severity, message, ...))
	end

	local function info(message: string, ...)
		log("info", message, ...)
	end

	local function warning(message: string, ...: any)
		log("warning", message, ...)
	end

	local function error(message: string, ...: any)
		log("error", message, ...)
	end

	local function fatal(message: string, ...: any)
		log("fatal", message, ...)
	end

	local configured_logger = {
		info = info,
		warning = warning,
		error = error,
		fatal = fatal,
	}

	return configured_logger
end

return logger
