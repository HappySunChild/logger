export type Error = {
	type: "Error",
	raw: string,
	message: string,
	trace: string,
}

local function parse_error(message: string): Error
	return {
		type = "Error",
		raw = message,
		message = string.gsub(message, "^.+:%d+:%s*", ""),
		trace = debug.traceback(nil, 2),
	}
end

return parse_error
