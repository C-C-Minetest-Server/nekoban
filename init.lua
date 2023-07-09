local MP = minetest.get_modpath("nekoban")

-- Load logger
local logger = dofile(MP .. "/" .. "logger.lua")
local log = logger("nekoban")

nekoban = {}

nekoban.S = minetest.get_translator("nekoban")
local   S = nekoban.S

-- Ban data
nekoban.userban    = serialize_lib.load_atomic("nekoban-userban")
nekoban.ipban      = serialize_lib.load_atomic("nekoban-ipban")
nekoban.iprangeban = serialize_lib.load_atomic("nekoban-iprangeban")

-- Saving files
local function save(do_after)
	local savetable = {
		userban = nekoban.userban,
		ipban = nekoban.ipban,
		iprangeban = nekoban.iprangeban
	}
	serialize_lib.save_atomic_multiple(savetable, "nekoban-")
	if do_after then
		minetest.after(60,save,true)
	end
end
minetest.register_on_shutdown(function()
	save(false)
end)
minetest.after(60,save,true)
