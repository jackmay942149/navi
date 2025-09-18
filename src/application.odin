package src

import fmt "core:fmt"
import str "core:strings"
import rl  "vendor:raylib"

App_Input_Ctx :: struct {
	selected_node:   ^Node,
	select_type:     Selection_Type,
	inspector_state: Inspector_State,
}

@(private = "file")
Selection_Type :: enum {
	None,
	Whole_Node,
	Member_Out,
	Exec_Out,
	Exec_In,
	Function_Input,
	Member_Add,
	Function_Add,
	Whole_Member,
	Whole_Function,
	Inspector,
}

@(private = "file")
Inspector_State :: enum {
	Add,
	Change,
}

application_init :: proc(width, height: i32, title: cstring) -> (app_input_ctx: App_Input_Ctx) {
	rl.InitWindow(width, height, title)
	rl.SetTargetFPS(60)
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
	input_poll(class, app_input_ctx)
	for member in class.members {
		application_draw_member(member)
	}
	for func in class.functions {
		application_draw_function(func)
	}
	application_draw_lines(class)
	application_draw_inspector(app_input_ctx)
	rl.EndDrawing()
}

application_close :: proc() {
	rl.CloseWindow()
}

@(private)
application_draw_member :: proc(member: ^Variable) {
	assert(member != nil)
	rec := rl.Rectangle{f32(member.pos.x), f32(member.pos.y), 100, 30}
	round: f32 = size_member_roundedness
	seg:   i32 = size_segments

	// Node BG
	col := color_member_bg
	rl.DrawRectangleRounded(rec, round, seg, col) 

	// Node Outline
	col = color_member_outline
	rl.DrawRectangleRoundedLinesEx(rec, round, seg, 2, col)

	// Output Pin
	member_out_pos := node_get_member_pos_i32(member)
	col = color_member_output_outline
	node_identifier := Variable_Type_Id[member.type]
	rl.DrawCircleLines(member_out_pos.x, member_out_pos.y, size_member_output, col) 

	// Output Identifier
	col = color_font_member
	rl.DrawText(node_identifier, member_out_pos.x - 7, member_out_pos.y - 5, size_font / 2, col) 

	// Member Name
	cst := str.clone_to_cstring(member.name, context.temp_allocator)
	col = color_font_member
	rl.DrawText(cst, member.node.pos.x + 10, member.node.pos.y + 5, size_font, col) 
	free_all(context.temp_allocator)
	return
}

application_draw_function :: proc(func: ^Function) {
	assert(func != nil)

	// Node BG
	rec := rl.Rectangle{f32(func.pos.x), f32(func.pos.y), f32(func.node.size.x), f32(func.node.size.y)}
	round: f32 = size_func_roundedness
	seg: i32 = size_segments
	col := color_func_bg
	rl.DrawRectangleRounded(rec, round, seg, col)

	// Node Outline
	col = color_func_outline
	rl.DrawRectangleRoundedLinesEx(rec,	round, seg,	2,	col)

	// Exec Out Pin
	pos := node_get_exec_out_pos_i32(func)
	col = color_func_exec_outline
	rl.DrawCircleLines(pos.x, pos.y, size_func_exec, col)

	// Exec In Pin
	pos = node_get_exec_in_pos_i32(func)
	col = color_func_exec_outline
	if func.exec_in_count == 1 {
		rl.DrawCircleLines(pos.x, pos.y, size_func_exec, col)
	}

	// Function Inputs
	if func.input_count > 0 {
		for input, i in func.inputs {
			pos := node_get_input_in_pos_i32(func, i)
			col = color_func_input_outline
			rl.DrawCircleLines(pos.x, pos.y, size_func_input, col)
		}
	}

	// Function Name
	col = color_font
	csr := str.clone_to_cstring(func.name, context.temp_allocator)
	rl.DrawText(csr, func.pos.x + 10, func.node.pos.y + 5, size_font, col)
	free_all(context.temp_allocator)
	return
}

application_draw_lines :: proc(class: ^Class) {
	assert(class != nil)

	for func in class.functions {
		// Function Inputs
		for input, i in func.inputs {
			if input == nil {
				continue
			}

			// Input Filled
			member_pos := node_get_member_pos_i32(input)
			input_pos := node_get_input_in_pos_i32(func, i)
			col := color_func_input_filled
			rl.DrawCircle(input_pos.x, input_pos.y, size_func_input, col)

			// Member Filled
			col = color_member_output_filled
			rl.DrawCircle(member_pos.x, member_pos.y, size_member_output + 1, col)

			// Line Between
			col = color_member_to_func_line
			member_pos_f32 := node_get_member_pos_f32(input)
			input_pos_f32 := node_get_input_in_pos_f32(func, i)
			rl.DrawLineBezier(input_pos_f32, member_pos_f32, 2, col)
		}

		// Function Exec lines
		if func.exec_outs[0] != nil {
			exec_out_pos := node_get_exec_out_pos_f32(func)
			exec_in_pos := node_get_exec_in_pos_f32(func.exec_outs[0])
			rl.DrawLineBezier(exec_in_pos, exec_out_pos, 2,	color_func_exec_line)
			rl.DrawCircle(i32(exec_in_pos.x), i32(exec_in_pos.y), size_func_exec, color_func_exec_filled)
			rl.DrawCircle(i32(exec_out_pos.x), i32(exec_out_pos.y), size_func_exec, color_func_exec_filled)
		}
	}
}

application_draw_inspector :: proc(app_input_ctx: ^App_Input_Ctx) {
	assert(app_input_ctx != nil)
	// Draw Background
	rl.DrawRectangle(size_window_width - size_inspector_width, 0, size_inspector_width, size_window_height, color_inspector_bg)

	switch app_input_ctx.inspector_state {
	// Draw Member Details
	case .Change: {
		rl.DrawText("Member Details", size_window_width - size_inspector_width + 10, 30, size_font, color_font_member)
		rl.DrawText("Type:", size_window_width - size_inspector_width + 10, 60, size_font, color_font_member)
		assert(app_input_ctx.selected_node != nil) 
		rl.DrawText(Variable_Type_As_CString[app_input_ctx.selected_node.variant.(^Variable).type], size_window_width - size_inspector_width + 150, 60, size_font, color_font_member)
		rl.DrawText("Name:", size_window_width - size_inspector_width + 10, 90, size_font, color_font_member)
		cst := str.clone_to_cstring(app_input_ctx.selected_node.variant.(^Variable).name)
		rl.DrawText(cst, size_window_width - size_inspector_width + 150, 90, size_font, color_font_member)
		rl.DrawText("Initial Value:", size_window_width - size_inspector_width + 10, 120, size_font, color_font_member)
		cst = str.clone_to_cstring(app_input_ctx.selected_node.variant.(^Variable).value)
		rl.DrawText(cst, size_window_width - size_inspector_width + 150, 120, size_font, color_font_member)
	}

	// Draw Add Member and Function Window
	case .Add: {
		rl.DrawText("Available Types", size_window_width - size_inspector_width + 10, 30, size_font, color_font_member)
		member_count: int
		for type, i in Available_Types {
			rl.DrawRectangle(size_window_width - size_inspector_width + 5, 60 + 30 * i32(i), size_inspector_width / 2, 25, color_inspector_member_add)
			rl.DrawText(Variable_Type_As_CString[type.type], size_window_width - size_inspector_width + 10, 60 + 30 * i32(i), size_font, color_font)
			member_count = i
		}
		rl.DrawText("Available Functions", size_window_width - size_inspector_width + 10, 90 + 30 * i32(member_count), size_font, color_font_member)
		for func, i in Available_Functions {
			rl.DrawRectangle(size_window_width - size_inspector_width + 5, 120 + 30 * i32(member_count + i), size_inspector_width / 2, 25, color_inspector_member_add)
			csr := str.clone_to_cstring(func.name, context.temp_allocator)
			rl.DrawText(csr, size_window_width - size_inspector_width + 10, 120 + 30 * i32(member_count + i), size_font, color_font)
		}
	}	
	}
}
