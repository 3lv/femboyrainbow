local letters = { 'a', 'b', 'c', 'm' }
local prev_pos = { }
local function initpos ( buf )
	prev_pos[buf] = { }
	for _, v in ipairs(letters) do
		prev_pos[buf][v] = { line = 0, col = 0 }
	end
end

local ns_id = { }
for _, v in ipairs(letters) do
	ns_id[v] = vim.api.nvim_create_namespace('mark_'..v)
end

local function mark_hl()
	for _, v in ipairs(letters) do
		local pos = vim.fn.getpos("'"..v)
		local buf, line, col = vim.fn.bufnr('%'), pos[2], pos[3]
		if prev_pos[buf] == nil then initpos(buf) end
		local ns = ns_id[v]
		if line ~= prev_pos[buf][v].line or col ~= prev_pos[buf][v].col then
			vim.api.nvim_buf_clear_namespace( buf, ns, 0, -1 )
			if line ~= 0 or col ~= 0 then
				local hl_group = 'Rainbow'
				char = vim.api.nvim_get_current_line():sub(col,col)
				if char:match('%s') then
					hl_group = 'RainbowBg'
				end
				vim.api.nvim_buf_add_highlight(buf, ns, hl_group, line - 1, col - 1, col)
				vim.api.nvim_buf_set_virtual_text(buf, ns, line - 1, { { "  '"..v, hl_group} }, { })
			end
			prev_pos[buf][v].line = line
			prev_pos[buf][v].col = col
		end
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
	vim.api.nvim_command([[hi RainbowBg guibg=]]..hex)
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
