package src

import rl "vendor:raylib"

// Main Colours
@(private = "file") color_accent :: rl.Color{ 254,  198,  49, 255} 
@(private = "file") color_light1 :: rl.Color{ 237,  230, 217, 255} 
@(private = "file") color_light2 :: rl.Color{ 198,  198, 189, 255} 
@(private = "file") color_dark1 ::  rl.Color{ 140,  141, 135, 255} 
@(private = "file") color_dark2 ::  rl.Color{   0,    0,   0, 255} 

// Set Colours
color_bg        :: color_light2
color_font      :: color_dark2

color_member_bg      :: color_accent
color_member_outline :: color_dark2

color_func_bg :: color_dark1
color_func_outline :: color_light2

// Sizes
size_font :: 20
size_segments :: 4

size_member_output :: 8
size_member_roundedness :: 2

size_func_output :: 8
size_func_roundedness :: 0.1

// Offsets
offset_member_out :: [2]i32{80, 15}
offset_func_in :: [2]i32{20, 60}
offset_exec_in :: [2]i32{20, 40}
offset_exec_out :: [2]i32{180, 15}
