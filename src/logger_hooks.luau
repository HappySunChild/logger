export type HookMethod =
	| "prepend_annotations"
	| "append_annotations"
	| "on_raw_log"
	| "on_log"
	| "overwrite_message"
	| string
export type Hook<Keys = HookMethod> = { [Keys]: (...any) -> () }
export type LoggerHooks = { notify: (method_name: HookMethod, ...any) -> () }

local function logger_hooks(hooks: { Hook }?): LoggerHooks
	local new_logger_hooks = {
		notify = function(method_name: HookMethod, ...: any)
			if hooks == nil then
				return
			end

			for _, hook in hooks do
				local method = hook[method_name]

				if type(method) == "function" then
					method(...)
				end
			end
		end,
	}

	return new_logger_hooks
end

return logger_hooks
