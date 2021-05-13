local prev_pos = { m = { } }

local ns_id = vim.api.nvim_create_namespace('mark_a')

local function mark_hl()
	local pos = vim.fn.getpos("'m")
	local buf, line, col = pos[1], pos[2], pos[3]
	if line ~= prev_pos.m.line or col ~= prev_pos.m.col then
		vim.api.nvim_buf_clear_namespace( buf, ns_id, 0, -1 )
		vim.api.nvim_buf_add_highlight(buf, ns_id, 'Rainbow', line - 1, col - 1, col)
		vim.api.nvim_buf_add_highlight(buf, ns_id, line - 1, { { "  'm", 'Rainbow' } }, { })
		prev_poz.m.line = line
		prev_poz.m.col = col
	end
end

local function Rainbow_hl ( )
	Rainbowid = Rainbowid or 0
	Rainbowid = Rainbowid + 8
	if Rainbowid >= 256 * 6 then
		Rainbowid = 0
	end
	local d = Rainbowid % 256
	local slice = Rainbowid / 256
	slice = math.floor( slice )
	local r, g, b = 0, 0, 0
	if slice == 0 then
		r,g,b = 255,     d,       0
	elseif slice == 1 then
		r,g,b = 255 - d, 255,     0
	elseif slice == 2 then
		r,g,b = 0,       255,     d
	elseif slice == 3 then
		r,g,b = 0,       255 - d, 255
	elseif slice == 4 then
		r,g,b = d,       0,       255
	elseif slice == 5 then
		r,g,b = 255,     0,       255 - d
	end
	local hex = string.format("#%02X%02X%02X", r, g, b)
	vim.api.nvim_command([[hi Rainbow guifg=]]..hex)
end


local timer = vim.loop.new_timer()
local marktimer = vim.loop.new_timer()
local function Start_Rainbow()
	timer:start(0, 20, vim.schedule_wrap(Rainbow_hl))
	marktimer:start(0, 40, vim.schedule_wrap(mark_hl))
end

M = { }
M.start = Start_Rainbow
return M
