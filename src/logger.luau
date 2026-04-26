local logger_hooks = require("./logger_hooks")
local parse_error = require("./parse_error")

export type Options = {
	hooks: { logger_hooks.Hook }?,
}
export type Configured = {
	log: (message: string, ...any) -> (),
	warning: (message: string, err: parse_error.Error, ...any) -> (),
	error: (message: string, err: parse_error.Error, ...any) -> (),

	parse_error: typeof(parse_error),
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

local function logger(options: Options): Configured
	local hooks = logger_hooks(options.hooks)

	local function log(message: string)
		hooks.notify("raw_log", message)
		hooks.notify("log", get_annotated_message(hooks, message))
	end

	local function warning(message: string, err: parse_error.Error, ...: any)
		hooks.notify("raw_log_warning", message, err, ...)
		hooks.notify("log_warning", get_annotated_message(hooks, message, err, ...))
	end

	local function error(message: string, err: parse_error.Error, ...: any)
		hooks.notify("raw_log_error", message, err, ...)
		hooks.notify("log_error", get_annotated_message(hooks, message, err, ...))
	end

	local configured_logger = {
		log = log,
		warning = warning,
		error = error,

		parse_error = parse_error,
	}

	return configured_logger
end

return logger
