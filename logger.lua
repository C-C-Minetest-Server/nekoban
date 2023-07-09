-- A wrapper of minetest.log, inspired by Python `logging`

local metatable = {}

-- When the logger object is directly called
-- level: minetest.logging level
--        "none", "error", "warning", "action", "info", or "verbose". Default is "none"
-- msg: minetest.logging message
function metatable.__call(self,level,msg)
	if not msg then -- level is not given and msg is shifted into level param
		msg = level
		level = "none"
	end
	if type(msg) ~= "string" then
		msg = dump(msg) -- avoid error when concatenating strings
	end
	minetest.log(level,"[" .. self.name .. "] " .. msg)
end


function metatable.__index(self,key)
	if key == "sublogger" then -- Sublogger: name = orig_name .. "." .. subname
		return function(subname)
			return nekoapi.logger(self.name .. "." .. subname)
		end
	else -- logger_object[lvl](msg) -> logger_object(lvl,msg)
		return function(msg)
			self(key,msg)
		end
	end
end




-- Deny any newindex
metatable.__newindex = function()
	error("Attempt to set new value to a nekoapi.logger object")
end

-- The function construction a logger
-- name: The name of the program obtaining a logger, default: current modname
return function(name)
	if not name then
		name = minetest.get_current_modname()
		if not name then
			error("Could not obtain current modname, either solve it or give a parameter to nekoapi.logger!")
		end
	end

	-- Apply the metatable
	local R = setmetatable({name=name},metatable)
	return R
end
