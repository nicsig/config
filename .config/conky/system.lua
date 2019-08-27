-- conkyrc_seamod
-- Date    : 05/02/2012
-- Author  : SeaJey
-- Version : v0.1
-- License : Distributed under the terms of GNU GPL version 2 or later
--
-- This version is a modification of conkyrc_lunatico wich is modification of conkyrc_orange
--
-- conkyrc_orange:    http://gnome-look.org/content/show.php?content=137503&forumpage=0
-- conkyrc_lunatico:  http://gnome-look.org/content/show.php?content=142884

-- INFOS POUR CUSTOMIZER L'UI

-- Pour que le fond des éléments affichés soient transparents (et non pas noir) :
-- settings > window manager tweaks > compositor > enable display compositing

-- offset                                décalement horizontal
-- voffset                               décalement vertical (taille de l'espace séparant deux sections)
-- ${execi 10 <commande>}        exécute <commande> toutes les 10 secondes
-- align{l | c | r}              alignement à gauche, au centre, à droite

-- remplacer:
-- enp3s0                                   par le nom de l'interface réseau à surveiller
-- /media/jean/HDD-INT-500G     par le chemin vers la partition à surveiller
-- caption='HDD'                        par caption='<nom de la partition>'

-- pour modifier la taille de certaines infos, chercher size=

-- si l'affichage d'un nom de processus trop long entraîne un décalage régulier de tout le panneau d'infos
-- augmenter la valeur du paramètre minimum_size

-- FIXME: The percentage usage seems wrong (too high).{{{
--
-- I think it comes from the configuration setting `memprc`:
--
--     ~/.conky/system_rings.lua:55
--
-- From `$ man conky /memperc`:
--
--     memperc
--            Percentage of memory in use
--
-- On google, they suggest to set `no_buffers` to yes.
-- So, I tried  to add `no_buffers = yes,` inside  `conky.config`, but it didn't
-- reduce the memory percentage.
--}}}

conky.config = {
    background = true,
    update_interval = 1,
    cpu_avg_samples = 1,
    net_avg_samples = 2,
    temperature_unit = 'celsius',
    double_buffer = true,
    no_buffers = true,
    text_buffer_size = 2048,
    override_utf8_locale = true,
    use_xft = true,
    font = 'Caviar_Dreams:size=18',
    xftalpha = 0.5,
    uppercase = false,
    gap_x = 20,
    gap_y = 0,
    -- minimum_size = 600 900,
    maximum_width = 350,
    own_window = true,
    own_window_type = 'normal',
    own_window_transparent = false,
    own_window_argb_visual = true,
    own_window_colour = '000000',
    -- niveau de transparence compris entre 0 (0% opacité) et 255 (100% opacité)
    own_window_argb_value = 100,
    own_window_hints = 'undecorated,sticky,skip_taskbar,skip_pager,below',
    border_inner_margin = 0,
    border_outer_margin = 0,
    alignment = 'top_right',
    draw_shades = false,
    draw_outline = false,
    draw_borders = false,
    draw_graph_borders = false,
    -- defining colors
    default_color = 'FFFFFF',
    -- white
    color1 = 'DDDDDD',
    -- grey
    color2 = 'AAAAAA',
    color3 = 'lightgreen',
    color4 = 'yellow',
    -- loading lua script for drawning rings
    lua_load = './system_rings.lua',
    lua_draw_hook_post = 'main',
}

-- -- System information using conky capabilities

-- TODO: We use `$ sensors | awk '/Package id/{print $4}'` to get the cpu temperature. Is it reliable?
-- There are many temperatures in the output of `$ sensors`. Which one should we extract?

conky.text = [[
${voffset -10}
${font Ubuntu:bold:size=18}${color3}SYSTEM ${hr 2}
${voffset 0}
${offset 15}${font Ubuntu:normal:size=18}${color1}T° cpu${alignc}${color4}${execi 10 sensors | awk '/Package id/{print $4}'}
${offset 15}${font Ubuntu:normal:size=18}${color1}Uptime${alignc}$color4$uptime

${offset 140}${font Ubuntu:bold:size=18}${color3}CPU${voffset -30}
${offset 120}${cpugraph 40,183 666666 666666}${voffset 0}
${offset 105}${font Ubuntu:normal:size=18}${color4}${top name 1}${alignr}${top cpu 1}%
${offset 105}${font Ubuntu:normal:size=18}${color1}${top name 2}${alignr}${top cpu 2}%
${offset 105}${font Ubuntu:normal:size=18}${color2}${top name 3}${alignr}${top cpu 3}%

${voffset 0}
${offset 150}${font Ubuntu:normal:size=18}${color1}Swap ${alignr}$color4$swap / $swapmax
${voffset 0}
${offset 140}${font Ubuntu:bold:size=18}${color3}MEM
${voffset 0}
${offset 105}${font Ubuntu:normal:size=18}${color4}${top_mem name 1}${alignr}${top_mem mem 1}%
${offset 105}${font Ubuntu:normal:size=18}${color1}${top_mem name 2}${alignr}${top_mem mem 2}%
${offset 105}${font Ubuntu:normal:size=18}${color2}${top_mem name 3}${alignr}${top_mem mem 3}%

${voffset 20}
${offset 140}${font Ubuntu:bold:size=18}${color3}PARTITIONS
${offset 120}${diskiograph 33,183 666666 666666}${voffset -30}
${voffset 30}
${offset 15}${font Ubuntu:bold:size=14}${color1}${offset 50}Free${alignr}Used
${offset 15}${font Ubuntu:bold:size=14}${color1}Root     ${font Ubuntu:normal:size=14}${color4}${fs_free /}${alignr}${fs_used /}
${offset 15}${font Ubuntu:bold:size=14}${color1}HDD     ${font Ubuntu:normal:size=14}${color4}${fs_free /media/jean/HDD-INT-500G}${alignr}${font Ubuntu:normal:size=14}${fs_used /media/jean/HDD-INT-500G}
${voffset 5}
${voffset 5}
${offset 15}${color1}ip locale${alignr}$color4${execi 10 ip a|grep global|head -n1|cut -d' ' -f6|cut -d/ -f1}
${voffset 0}
${offset 15}${color1}${font Ubuntu:bold:size=14}Up${alignc}${font Ubuntu:normal:size=14}$color4${if_up enp3s0}${upspeed enp3s0}${endif}${if_up eth0}${upspeed eth0}${endif}${if_up wlan0}${upspeed wlan0}${endif}
${offset 15}${if_up enp3s0}${upspeedgraph enp3s0 40,285 666666 666666 100 -l}${endif}${if_up eth0}${upspeedgraph eth0 40,285 666666 666666 100 -l}${endif}${if_up wlan0}${upspeedgraph wlan0 40,285 666666 666666 100 -l}${endif}
${offset 15}${color1}${font Ubuntu:bold:size=14}Down${alignc}${font Ubuntu:normal:size=14}$color4${if_up enp3s0}${downspeed enp3s0}${endif}${if_up eth0}${downspeed eth0}${endif}${if_up wlan0}${downspeed wlan0}${endif}
${offset 15}${if_up enp3s0}${downspeedgraph enp3s0 40,285 666666 666666 100 -l}${endif}${if_up eth0}${downspeedgraph eth0 40,285 666666 666666 100 -l}${endif}${if_up wlan0}${downspeedgraph wlan0 40,285 666666 666666 100 -l}${endif}
${color3}${hr 2}
]]
