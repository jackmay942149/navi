package src

import fmt "core:fmt"
import str "core:strings"
import rl  "vendor:raylib"

App_Input_Ctx :: struct {
	selected_node: ^Node,
	select_type:   Selection_Type,
}

@(private = "file")
Selection_Type :: enum {
	None,
	Whole_Node,
	Member_Out,
	Exec_Out,
	Exec_In,
	Function_Input,
}

application_init :: proc(width, height: i32, title: cstring) -> (app_input_ctx: App_Input_Ctx) {
	rl.InitWindow(width, height, title)
	return app_input_ctx
}

application_should_close :: proc() -> bool {
	return rl.WindowShouldClose()
}

application_update :: proc(class: ^Class, app_input_ctx: ^App_Input_Ctx) {
	assert(class != nil)
	assert(app_input_ctx != nil)

	rl.BeginDrawing()
	rl.ClearBackground(color_bg)
	application_poll_input(class, app_input_ctx)
	for member in class.members {
		application_draw_member(member)
	}
	for func in class.functions {
		application_draw_function(func)
	}
	rl.EndDrawing()
}

application_close :: proc() {
	rl.CloseWindow()
}

@(private)
application_poll_input :: proc(class: ^Class, app_input_ctx: ^App_Input_Ctx) {
	assert(app_input_ctx != nil)
	assert(class != nil)

	mouse_pos := [2]i32{rl.GetMouseX(), rl.GetMouseY()}
	if rl.IsKeyPressed(.S) {
		_ = init_member_new(class, "Hello", .String, "Hello World", mouse_pos)
	}
	if rl.IsKeyPressed(.B) {
		_ = add_function(class, Unity_Start, mouse_pos)
	}
	if rl.IsKeyPressed(.D) {
		_ = add_function(class, Unity_DebugLog, mouse_pos)
	}
	if rl.IsMouseButtonPressed(.LEFT) {
		node := application_select(class)
		app_input_ctx.select_type = node.select_type
		app_input_ctx.selected_node = node.selected_node
		fmt.println(node)
	}
	if rl.IsMouseButtonReleased(.LEFT) {
		application_deselect(class, app_input_ctx)
		app_input_ctx.selected_node = nil
	}
	if app_input_ctx.selected_node == nil {
		return
	}

	#partial switch app_input_ctx.select_type {
	case .Whole_Node:	{
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
application_select :: proc(class: ^Class) -> (app_input_ctx: App_Input_Ctx) {
	mouse_pos := [2]f32{f32(rl.GetMouseX()), f32(rl.GetMouseY())}
	for member in class.members {
		rec := rl.Rectangle {
			x      = f32(member.node.pos.x),
			y      = f32(member.node.pos.y),
			width  = 100,
			height = 30,
		}
		if rl.CheckCollisionPointRec(mouse_pos, rec) {
			app_input_ctx.select_type = .Whole_Node
			member_pos := node_get_member_pos_f32(member)
			if rl.CheckCollisionPointCircle(mouse_pos, member_pos, size_member_output) {
				app_input_ctx.select_type = .Member_Out
			}
			app_input_ctx.selected_node = member
			return app_input_ctx
		}
	}
	for func in class.functions {
		rec := rl.Rectangle {
			x      = f32(func.pos.x),
			y      = f32(func.pos.y),
			width  = 200,
			height = 100,
		}
		if rl.CheckCollisionPointRec({f32(rl.GetMouseX()), f32(rl.GetMouseY())}, rec) {
			app_input_ctx.select_type = .Whole_Node
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
			return app_input_ctx
		}
	}
	return {}
}

@(private)
application_deselect :: proc(class: ^Class, app_input_ctx: ^App_Input_Ctx) {
	assert(class != nil)
	assert(app_input_ctx != nil)
	release_ctx := application_select(class)
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
	}
}

@(private)
application_draw_member :: proc(member: ^Variable) {
	assert(member != nil)
	rec := rl.Rectangle{f32(member.pos.x), f32(member.pos.y), 100, 30}
	rl.DrawRectangleRounded(rec, size_member_roundedness, size_segments, color_member_bg) // Node BG
	rl.DrawRectangleRoundedLinesEx(
		rec,
		size_member_roundedness,
		size_segments,
		2,
		color_member_outline,
	) // Node Outline
	rl.DrawCircleLines(
		member.pos.x + 80,
		member.pos.y + 15,
		size_member_output,
		color_member_output_outline,
	) // Output Node
	rl.DrawText("S", member.pos.x + 77, member.pos.y + 10, size_font / 2, color_font_member) // Output Type
	csr := str.clone_to_cstring(member.name, context.temp_allocator)
	rl.DrawText(csr, member.node.pos.x + 10, member.node.pos.y + 5, size_font, color_font_member) // Name
	free_all(context.temp_allocator)
	return
}

application_draw_function :: proc(func: ^Function) {
	assert(func != nil)
	rec := rl.Rectangle{f32(func.pos.x), f32(func.pos.y), 200, 100}
	rl.DrawRectangleRounded(rec, size_func_roundedness, size_segments, color_func_bg) // Node BG
	rl.DrawRectangleRoundedLinesEx(rec,	size_func_roundedness, size_segments,	2,	color_func_outline) // Node Outline
	rl.DrawCircleLines(func.pos.x + 180, func.pos.y + 15, size_func_exec, color_func_exec_outline) // Node Output
	if func.exec_in_count == 1 {
		rl.DrawCircleLines(func.pos.x + 20, func.pos.y + 40, size_func_exec, color_func_exec_outline) // Node Exec Input
	}
	if func.input_count > 0 {
		input_pos := node_get_input_in_pos_f32(func, 0)
		rl.DrawCircleLines(i32(input_pos.x), i32(input_pos.y), size_func_input, color_func_input_outline) // Node Inputs
		for input in func.inputs {
			if input == nil {
				continue
			}
			member_pos := node_get_member_pos_f32(input)
			rl.DrawCircle(i32(input_pos.x), i32(input_pos.y), size_func_input, color_func_input_filled)
			rl.DrawLineBezier(input_pos, member_pos, 2, color_member_to_func_line)
			rl.DrawCircle(i32(member_pos.x), i32(member_pos.y), size_member_output + 1, color_member_output_filled)
		}
	}
	if func.exec_outs[0] != nil {
		exec_out_pos := node_get_exec_out_pos_f32(func)
		exec_in_pos := node_get_exec_in_pos_f32(func.exec_outs[0])
		rl.DrawLineBezier(exec_in_pos, exec_out_pos, 2,	color_func_exec_line)
		rl.DrawCircle(i32(exec_in_pos.x), i32(exec_in_pos.y), size_func_exec, color_func_exec_filled)
		rl.DrawCircle(i32(exec_out_pos.x), i32(exec_out_pos.y), size_func_exec, color_func_exec_filled)
	}
	if func.exec_ins != nil && func.exec_ins[0] != nil {
		exec_out_pos := node_get_exec_out_pos_f32(func.exec_ins[0])
		exec_in_pos := node_get_exec_in_pos_f32(func)
		rl.DrawLineBezier(exec_in_pos, exec_out_pos, 2,	color_func_exec_line)
		rl.DrawCircle(i32(exec_in_pos.x), i32(exec_in_pos.y), size_func_exec, color_func_exec_filled)
		rl.DrawCircle(i32(exec_out_pos.x), i32(exec_out_pos.y), size_func_exec, color_func_exec_filled)
	}
	csr := str.clone_to_cstring(func.name, context.temp_allocator)
	rl.DrawText(csr, func.pos.x + 10, func.node.pos.y + 5, size_font, color_font) // Name
	free_all(context.temp_allocator)
	return
}

