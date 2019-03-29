-- https://imgur.com/a/yPAwz
-- https://www.reddit.com/r/Conkyporn/comments/5jej1p/conky_revisited/
-- http://xexpanderx.deviantart.com/art/Conky-revisited-652299968
-- https://drive.google.com/file/d/0B40OrWR_9-Q7YThvSFJVeUZydHc/view

conky.config = {
	background = false,
	update_interval = 1,

	override_utf8_locale = true,

	double_buffer = true,
	no_buffers = true,

	text_buffer_size = 2048,
	imlib_cache_size = 0,

	own_window = true,
	own_window_type = 'desktop',
	own_window_transparent = true,
	own_window_argb_visual = true,
	own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',

	border_inner_margin = 0,
	border_outer_margin = 0,

	minimum_width = 235, minimum_height = 321,--width height

	alignment = 'middle_left',
	gap_x = 0,
	gap_y = 0,

	draw_shades = true,
	draw_outline = false,
	draw_borders = false,
	draw_graph_borders = false,

	use_xft = true,
	font = 'pftempestafivecondensed:size=6',
	xftalpha = 0.5,

	uppercase = false,

	lua_load = '~/.conky/Conky_Revisited/lua_widgets.lua',
	lua_draw_hook_pre = 'start_widgets',

};

conky.text = [[
]];
