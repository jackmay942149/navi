package src

import fmt "core:fmt"
import rl  "vendor:raylib"

@(private)
input_poll :: proc(class: ^Class, app_input_ctx: ^App_Input_Ctx) {
	assert(app_input_ctx != nil)
	assert(class != nil)

	mouse_pos := [2]i32{rl.GetMouseX(), rl.GetMouseY()}
	if rl.IsKeyPressed(.S) {
		_ = init_member_new(class, "Hello", .String, "Hello World", mouse_pos)
	}
	if rl.IsMouseButtonPressed(.LEFT) {
		input_select(class, app_input_ctx)
	}
	if rl.IsMouseButtonReleased(.LEFT) {
		input_deselect(class, app_input_ctx)
		return
	}
	if !rl.IsMouseButtonDown(.LEFT) {
		return
	}

	#partial switch app_input_ctx.select_type {
	case .Whole_Node, .Member_Add, .Function_Add, .Whole_Member, .Whole_Function:	{
		node_move(app_input_ctx.selected_node, mouse_pos.x, mouse_pos.y)
	}
	case .Member_Out:	{
		pos := node_get_member_pos_i32(app_input_ctx.selected_node)
		rl.DrawLine(pos.x, pos.y, mouse_pos.x, mouse_pos.y, color_member_to_func_line)
		rl.DrawCircle(pos.x, pos.y, size_member_output,	color_member_output_filled)
	}
	case .Exec_In: {
		pos := node_get_exec_in_pos_i32(app_input_ctx.selected_node)
		rl.DrawLine(pos.x, pos.y, mouse_pos.x, mouse_pos.y, color_func_exec_line)
		rl.DrawCircle(pos.x, pos.y, size_func_exec,	color_func_exec_filled)
	}
	case .Exec_Out: {
		pos := node_get_exec_out_pos_i32(app_input_ctx.selected_node)
		rl.DrawLine(pos.x, pos.y, mouse_pos.x, mouse_pos.y, color_func_exec_line)
		rl.DrawCircle(pos.x, pos.y, size_func_exec,	color_func_exec_filled)
	}
	}
}

@(private)
input_select :: proc(class: ^Class, app_input_ctx: ^App_Input_Ctx) {
	mouse_pos := [2]f32{f32(rl.GetMouseX()), f32(rl.GetMouseY())}
	// Check Selection of member to add 
	for member, i in Available_Types {
		if app_input_ctx.inspector_state == .Change {
			break
		}
		rec := rl.Rectangle {
			x = size_window_width - size_inspector_width + 5,
			y = f32(60 + 30 * i32(i)), 
			width = size_inspector_width / 2,
			height = 25,
		}
		if rl.CheckCollisionPointRec(mouse_pos, rec) {
			app_input_ctx.select_type = .Member_Add
			type := Available_Types[i]
			new_node := init_member_defined(class, "", type, {i32(mouse_pos.x), i32(mouse_pos.y)})
			app_input_ctx.selected_node = new_node
			app_input_ctx.inspector_state = .Change
			return
		}
	}
	// Check Selection of function to add 
	for func, i in Available_Functions {
		if app_input_ctx.inspector_state == .Change {
			break
		}
		rec := rl.Rectangle {
			x = size_window_width - size_inspector_width + 5,
			y = f32(90 + 30 * i32(i + len(Available_Types))), 
			width = size_inspector_width / 2,
			height = 25,
		}
		if rl.CheckCollisionPointRec(mouse_pos, rec) {
			app_input_ctx.select_type = .Function_Add
			type := Available_Functions[i]
			new_node := add_function_defined(class, type, {i32(mouse_pos.x), i32(mouse_pos.y)})
			app_input_ctx.selected_node = new_node
			app_input_ctx.inspector_state = .Add
			return
		}
	}
	// Check Selection of Class Member
	for member in class.members {
		rec := rl.Rectangle {
			x      = f32(member.node.pos.x),
			y      = f32(member.node.pos.y),
			width  = 100,
			height = 30,
		}
		if rl.CheckCollisionPointRec(mouse_pos, rec) {
			app_input_ctx.select_type = .Whole_Member
			member_pos := node_get_member_pos_f32(member)
			app_input_ctx.inspector_state = .Change
			if rl.CheckCollisionPointCircle(mouse_pos, member_pos, size_member_output) {
				app_input_ctx.select_type = .Member_Out
				app_input_ctx.inspector_state = .Add
			}
			app_input_ctx.selected_node = member
			return
		}
	}

	// Check selection of class function
	for func in class.functions {
		rec := rl.Rectangle {
			x      = f32(func.pos.x),
			y      = f32(func.pos.y),
			width  = 200,
			height = 100,
		}
		if rl.CheckCollisionPointRec({f32(rl.GetMouseX()), f32(rl.GetMouseY())}, rec) {
			app_input_ctx.select_type = .Whole_Function
			input_pos := node_get_input_in_pos_f32(func, 0)
			exec_in_pos := node_get_exec_in_pos_f32(func)
			exec_out_pos := node_get_exec_out_pos_f32(func)
			if func.input_count > 0 && rl.CheckCollisionPointCircle(mouse_pos, input_pos, size_func_exec) {
				app_input_ctx.select_type = .Function_Input
				fmt.println("Released on func input")
			} else if func.exec_in_count == 1 && rl.CheckCollisionPointCircle(mouse_pos, exec_in_pos, size_func_exec) {
				app_input_ctx.select_type = .Exec_In
			} else if func.exec_out_count == 1 && rl.CheckCollisionPointCircle(mouse_pos, exec_out_pos, size_func_exec) {
				app_input_ctx.select_type = .Exec_Out
			}
			app_input_ctx.selected_node = func
			app_input_ctx.inspector_state = .Add
			return 
		}
	}

	rec := rl.Rectangle {
		x      = size_window_width - size_inspector_width,
		y      = 0,
		width  = size_inspector_width,
		height = size_window_height,
	}
	if rl.CheckCollisionPointRec({f32(rl.GetMouseX()), f32(rl.GetMouseY())}, rec) && app_input_ctx.inspector_state == .Change {
		app_input_ctx.inspector_state = .Change
		app_input_ctx.select_type = .Inspector
		return 
	}
	app_input_ctx.select_type = .None
	app_input_ctx.inspector_state = .Add
	return 
}

@(private)
input_deselect :: proc(class: ^Class, app_input_ctx: ^App_Input_Ctx) {
	assert(class != nil)
	assert(app_input_ctx != nil)
	release_ctx: App_Input_Ctx
	release_ctx = app_input_ctx^
	input_select(class, &release_ctx)
	switch app_input_ctx.select_type {
	case .None:	{
			return
	}
	case .Exec_Out: {
		if release_ctx.select_type == .Exec_In {
			from := app_input_ctx.selected_node.variant.(^Function)
			to := release_ctx.selected_node.variant.(^Function)
			link_function(from, to)
		}
		return
	}
	case .Member_Out:	{
		if release_ctx.select_type == .Function_Input {
			var := app_input_ctx.selected_node.variant.(^Variable)
			func := release_ctx.selected_node.variant.(^Function)
			link_variable(var, func)
		}
		return
	}
	case .Whole_Node:	{
		return
	}
	case .Function_Input:	{
		return
	}
	case .Exec_In: {
		return
	}
	case .Member_Add: {
		return
	}
	case .Function_Add: {
		return
	}
	case .Whole_Function: {
		return
	}
	case .Whole_Member: {
		return
	}
	case .Inspector: {
		return
	}
	}
}
