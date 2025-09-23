package src

import rl "vendor:raylib"

// Main Colours
@(private = "file") color_accent :: rl.Color{ 254,  198,  49, 255} 
@(private = "file") color_light1 :: rl.Color{ 237,  230, 217, 255} 
@(private = "file") color_light2 :: rl.Color{ 198,  198, 189, 255} 
@(private = "file") color_dark1 ::  rl.Color{ 140,  141, 135, 255} 
@(private = "file") color_dark2 ::  rl.Color{   0,    0,   0, 255} 

// Set Colours
color_bg               :: color_accent
color_font             :: color_accent
color_font_member      :: color_dark2
color_font_func        :: color_dark1

color_member_bg             :: color_light1
color_member_outline        :: color_light1
color_member_output_outline :: color_dark2
color_member_output_filled  :: color_light1
color_member_to_func_line   :: color_light1

color_func_bg               :: color_dark2
color_func_outline          :: color_dark2
color_func_exec_outline     :: color_accent
color_func_exec_filled      :: color_accent
color_func_exec_line        :: color_dark2
color_func_input_outline    :: color_light1
color_func_input_filled     :: color_light1
color_func_divider          :: color_accent
color_func_ouput_outline    :: color_accent
color_member_to_output_line :: color_dark2
color_func_output_filled    :: color_accent
color_member_to_out_filled  :: color_dark2

color_inspector_bg         :: color_light1
color_inspector_member_add :: color_dark2

color_inspector_edit_bg   :: color_dark2
color_inspector_edit_font :: color_accent

color_split_bg   :: color_dark2
color_split_pin  :: color_accent
color_split_font :: color_accent

// Sizes
size_window_width  :: 1800
size_window_height :: 900
size_font          :: 20
size_segments      :: 4

size_member_w           :: 100
size_member_h           :: 30
size_member_output      :: 10
size_member_roundedness :: 2
size_character          :: 10

size_func_w           :: 200
size_func_h           :: 150
size_func_output      :: 12
size_func_exec        :: 12
size_func_input       :: 8
size_func_roundedness :: 0.1

size_inspector_width :: 400

size_split_pin :: 8

// Offsets
offset_member_out :: [2]i32{80, 15}
offset_func_in    :: [2]i32{20, 65}
offset_exec_in    :: [2]i32{20, 40}
offset_exec_out   :: [2]i32{180, 15}

offset_inspector_margin_1 :: size_window_width - size_inspector_width + 10
offset_inspector_margin_2 :: size_window_width - size_inspector_width + 150
offset_inspector_edit :: size_window_width - size_inspector_width + 320
