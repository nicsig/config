--Colors
HTML_colors = "#444444"
HTML_border_colors = "#000000"
transparency = 1.0 -- From 0 to 1
transparency_border = 1.0

-- Change position of Conky
gap_x = 10
gap_y = 10

--[[
Show battery:
	true
	false
]]--
battery = false

--[[
Modes:
	1 = Show background area
	2 = No background area
]]--
mode = 1

-- Adjust conky elements on x-axis.  Positive and negative number moves elements to left and right, respectively.
adjust = 59

-- Adjust background area width.
back_x = -5

-- Path of drives for free space status.
drive_paths = {"/home", "/"}

-- Names of drives for free space status.
drive_names = {"Home", "Root"}

--Number of drives to show free space status.  Adjust the conky "height"-parameter in config manually to adjust for the increase in Conky height when adding more drives.
drives = 2


--[[
-- DON'T EDIT BELOW IF YOU DO NOT KNOW WHAT YOU ARE DOING!!!
]]--

require 'cairo'

function hex2rgb(hex)
	hex = hex:gsub("#","")
	return (tonumber("0x"..hex:sub(1,2))/255), (tonumber("0x"..hex:sub(3,4))/255), tonumber(("0x"..hex:sub(5,6))/255)
end

r,g,b = hex2rgb(HTML_colors)

r_border, g_border, b_border = hex2rgb(HTML_border_colors)

function draw_square(cr,w,h,align,pos_x,pos_y,rectangle_x,rectangle_y)
	if mode == 1 then
		cairo_set_operator(cr, CAIRO_OPERATOR_SOURCE)
	elseif mode == 2 then
		cairo_set_operator(cr, CAIRO_OPERATOR_CLEAR)
	end

	cairo_set_source_rgba(cr, r,g,b,transparency)
	cairo_set_line_width(cr, 1)

	cairo_rectangle(cr, pos_x, pos_y, rectangle_x+back_x, rectangle_y)
	cairo_fill(cr)
	cairo_set_source_rgba(cr, r_border,g_border,b_border,transparency_border)
	cairo_set_line_width(cr, 1)
	cairo_set_operator(cr, CAIRO_OPERATOR_ATOP)
	cairo_rectangle(cr, pos_x, pos_y, rectangle_x+back_x, rectangle_y)
	cairo_stroke(cr)

--[[
  cairo_set_line_width(cr, 1)

  if align == "Right" then
	cairo_move_to(cr,x_rel_pos+(w-pos_x+3-rectangle_x), y_rel_pos+pos_y+3)
  else
	cairo_move_to(cr,x_rel_pos+pos_x-3,y_rel_pos+pos_y+3)
  end

  cairo_set_source_rgba(cr, r_border,g_border,b_border,transparency_border)

  cairo_rel_line_to(cr,rectangle_x-6,0)
  cairo_rel_line_to(cr,0,rectangle_y-6)
  cairo_rel_line_to(cr,-(rectangle_x-6),0)
  cairo_close_path(cr)
  cairo_set_line_join (cr, CAIRO_LINE_JOIN_MITER)
  cairo_set_operator(cr, CAIRO_OPERATOR_CLEAR)
  cairo_stroke(cr)
]]--

end

function draw_battery(cr,w,h, align, pos_x, pos_y, rectangle_x,rectangle_y)
	if mode == 1 then
		cairo_set_operator(cr, CAIRO_OPERATOR_CLEAR)
	elseif mode == 2 then
		cairo_set_operator(cr, CAIRO_OPERATOR_SOURCE)
	end

	cairo_set_source_rgba(cr, r,g,b,transparency)
	cairo_set_line_width(cr, 2)
	set_battery_blocks_x = 0
	gap_y_ = 10
	set_battery_blocks_y = 16+gap_y_

	number_of_charges = math.floor((8 / 100)*tonumber(conky_parse('${battery_percent}')))

	for i=1,number_of_charges do
		cairo_rectangle(cr,pos_x+(rectangle_x/2)-adjust-41+4+set_battery_blocks_x,(pos_y)+set_battery_blocks_y,6,20)
		cairo_fill(cr)
		set_battery_blocks_x = set_battery_blocks_x + 9
	end

	set_battery_blocks_y = 27
	cairo_move_to(cr,pos_x+(rectangle_x/2)-adjust-41,(pos_y+3)+set_battery_blocks_y+10+gap_y_)

	set_battery_blocks_x = 82
	cairo_rel_line_to(cr,set_battery_blocks_x-5,0)
	cairo_rel_line_to(cr,0,-((set_battery_blocks_y-10)/2))
	cairo_rel_line_to(cr,5,0)
	cairo_rel_line_to(cr,0,-10)
	cairo_rel_line_to(cr,-5,0)
	cairo_rel_line_to(cr,0,-10)
	cairo_rel_line_to(cr,-(set_battery_blocks_x-5),0)
	cairo_close_path(cr)
	cairo_stroke(cr)

	gap_y_text = 0
	percent_font_size = 31
	cairo_move_to(cr,pos_x+(rectangle_x/2)-adjust-41+set_battery_blocks_x+10, percent_font_size+10+gap_y_text)

	cairo_set_font_size(cr,percent_font_size)

	percent = conky_parse('${battery_percent}')

	if string.len(percent) == 1 then
		cairo_show_text(cr,"0" .. percent .. "%")
	elseif string.len(percent) == 3 then
		cairo_show_text(cr,"Full")
	else
		cairo_show_text(cr,percent .. "%")
	end

	cairo_move_to(cr,pos_x+(rectangle_x/2)-adjust-41+set_battery_blocks_x+10, percent_font_size+10+gap_y_text+18)

	cairo_set_font_size(cr,12)
	status = conky_parse('${battery}')
	if string.find(status, "discharging") then
		status = "Discharging"
	elseif string.find(status, "charging") then
		status = "Charging"
	else
		status = ""
	end
	cairo_show_text(cr, status)
	cairo_move_to(cr,pos_x+(rectangle_x/2)-adjust-41+set_battery_blocks_x+10, percent_font_size+10+gap_y_text+18+14)
	cairo_show_text(cr, conky_parse('${battery_time}'))
end

function draw_folder(cr,w,h, align, pos_x, pos_y, rectangle_x,rectangle_y, hdd,pos_y_folder, folder_name)
	if mode == 1 then
		cairo_set_operator(cr, CAIRO_OPERATOR_CLEAR)
	elseif mode == 2 then
		cairo_set_operator(cr, CAIRO_OPERATOR_SOURCE)
	end

	cairo_set_source_rgba(cr, r,g,b,transparency)
	cairo_set_line_width(cr, 1)
	size = 30

	cairo_move_to(cr,((rectangle_x-size)/2)+pos_x-adjust, pos_y+pos_y_folder)

	cairo_rel_line_to(cr,size/2,-9)
	cairo_rel_line_to(cr,size/2,9)
	cairo_rel_line_to(cr,0,4)
	cairo_rel_line_to(cr,-size/2,-9)
	cairo_rel_line_to(cr,-size/2,9)
	cairo_close_path(cr)
	cairo_fill(cr)

	cairo_move_to(cr,((rectangle_x-size)/2)+pos_x-adjust+24, pos_y+pos_y_folder-6)

	cairo_rel_line_to(cr,4,2)
	cairo_rel_line_to(cr,0,-5)
	cairo_rel_line_to(cr,-4,0)
	cairo_close_path(cr)
	cairo_fill(cr)

	cairo_move_to(cr,((rectangle_x-size)/2)+pos_x-adjust+4, pos_y+pos_y_folder+5)

	cairo_rel_line_to(cr,11,-7)
	cairo_rel_line_to(cr,11,7)
	cairo_rel_line_to(cr,0,15)
	cairo_rel_line_to(cr,-8,0)
	cairo_rel_line_to(cr,0,-6)
	cairo_rel_line_to(cr,-6,0)
	cairo_rel_line_to(cr,0,6)
	cairo_rel_line_to(cr,-8,0)
	cairo_close_path(cr)
	cairo_fill(cr)

-- Draw indicator

	local distance_between_arcs = 7
	local number_of_arcs = 10
	local arcs_length = (360 - (number_of_arcs*distance_between_arcs)) / number_of_arcs
	local start_angel = 270
	local used_blocks = math.floor((number_of_arcs / 100) * tonumber(conky_parse('${fs_free_perc ' .. hdd .. '}')))
	local radius_outer = 41
	local radius_inner = 29
	local radius = 35
	cairo_set_line_width(cr, 2)

	cairo_arc(cr, pos_x+(rectangle_x/2)-adjust,pos_y+pos_y_folder+5,radius_outer,start_angel*math.pi/180,(start_angel+360)*math.pi/180)
	cairo_stroke(cr)
	cairo_arc(cr, pos_x+(rectangle_x/2)-adjust,pos_y+pos_y_folder+5,radius_inner,start_angel*math.pi/180,(start_angel+360)*math.pi/180)
	cairo_stroke(cr)

	cairo_set_line_width(cr, 6)
	for i=1, used_blocks do
		cairo_arc(cr, pos_x+(rectangle_x/2)-adjust,pos_y+pos_y_folder+5,radius,start_angel*math.pi/180,(start_angel+arcs_length)*math.pi/180)
		cairo_stroke(cr)
		start_angel = start_angel+arcs_length+distance_between_arcs
	end

	str = folder_name .. ": " .. conky_parse('${fs_free_perc ' .. hdd .. '}') .. "%"
	cairo_set_font_size(cr, 31)

    gap_y_text_adjust = 5
	cairo_move_to(cr, pos_x+(rectangle_x/2)-adjust+40+10,pos_y+pos_y_folder-5+gap_y_text_adjust)

	cairo_show_text(cr, conky_parse('${fs_free_perc ' .. hdd .. '}') .. "%")
	cairo_set_font_size(cr,12)

	cairo_move_to(cr, pos_x+(rectangle_x/2)-adjust+40+10,pos_y+pos_y_folder+13+gap_y_text_adjust)
	cairo_show_text(cr,folder_name)
	cairo_move_to(cr, pos_x+(rectangle_x/2)-adjust+40+10,pos_y+pos_y_folder+27+gap_y_text_adjust)
	cairo_show_text(cr,conky_parse('${fs_free ' .. hdd .. '}') .. " / " .. conky_parse('${fs_size ' .. hdd .. '}'))

end

function draw_function(cr)
	local w,h=conky_window.width,conky_window.height
	cairo_select_font_face (cr, "Dejavu Sans Book", CAIRO_FONT_SLANT_NORMAL, CAIRO_FOlNT_WEIGHT_NORMAL);

	-- Sizes of background
	local rectangle_x = 220
	local pos_first_hdd = 109
	local rectangle_y = 63 + 92*drives

	if tonumber(drives) > 0 then
		rectangle_y = rectangle_y + 10
	end

	if battery then
		draw_square(cr,w,h, align, gap_x, gap_y, rectangle_x,rectangle_y)
		draw_battery(cr,w,h, align, gap_x, gap_y, rectangle_x,rectangle_y)
	else
		pos_first_hdd = 46
		rectangle_y = rectangle_y - 63
		draw_square(cr,w,h, align, gap_x, gap_y, rectangle_x,rectangle_y)
	end

	for i=1,drives do
		draw_folder(cr,w,h, align, gap_x, gap_y, rectangle_x,rectangle_y, drive_paths[i],pos_first_hdd+92*(i-1), drive_names[i])
	end

end

function conky_start_widgets()
	local function draw_conky_function(cr)
		local str=''
		local value=0
		draw_function(cr)
	end

	-- Check that Conky has been running for at least 5s

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)

	local cr=cairo_create(cs)

	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)

	if update_num>5 then
		draw_conky_function(cr)
	end
	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end
