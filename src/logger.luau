local logger_hooks = require("./logger_hooks")

export type Options = {
	hooks: { logger_hooks.Hook }?,
}
export type ConfiguredLogger = {
	log: (message: string, ...any) -> (),
	warning: (message: string, ...any) -> (),
	error: (message: string, ...any) -> (),
}

local function get_annotated_message(hooks: logger_hooks.LoggerHooks, message: string, ...: any): string
	local prepend_annotations = {}
	local append_annotations = {}

	hooks.notify("prepend_annotations", function(annotation: string)
		table.insert(prepend_annotations, annotation)
	end, message, ...)
	hooks.notify("append_annotations", function(annotation: string)
		table.insert(append_annotations, annotation)
	end, message, ...)

	return `{table.concat(prepend_annotations, " ")} {message} {table.concat(append_annotations, " ")}`
end

local function logger(options: Options): ConfiguredLogger
	local hooks = logger_hooks(options.hooks)

	local function log(message: string, ...)
		hooks.notify("raw_log", message)
		hooks.notify("log", get_annotated_message(hooks, message, ...))
	end

	local function warning(message: string, ...: any)
		hooks.notify("raw_log_warning", message, ...)
		hooks.notify("log_warning", get_annotated_message(hooks, message, ...))
	end

	local function error(message: string, ...: any)
		hooks.notify("raw_log_error", message, ...)
		hooks.notify("log_error", get_annotated_message(hooks, message, ...))
	end

	local configured_logger = {
		log = log,
		warning = warning,
		error = error,
	}

	return configured_logger
end

return logger
