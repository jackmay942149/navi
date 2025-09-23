package src

import fmt "core:fmt"
import rl  "vendor:raylib"

@(private)
input_poll :: proc(class: ^Class, app_input_ctx: ^App_Input_Ctx) {
	assert(app_input_ctx != nil)
	assert(class != nil)

	mouse_pos := [2]i32{rl.GetMouseX(), rl.GetMouseY()}
	if rl.IsMouseButtonPressed(.LEFT) {
		input_select(class, app_input_ctx)
	}
	if rl.IsMouseButtonReleased(.LEFT) {
		input_deselect(class, app_input_ctx)
		return
	}
	if app_input_ctx.select_type == .Change_Name {
		change_name(app_input_ctx.selected_node)
	}
	if app_input_ctx.select_type == .Change_Value {
		change_value(app_input_ctx.selected_node)
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

@(private = "file")
select_new_member :: proc(class: ^Class, inspector_state: Inspector_State, mouse_pos: [2]f32) -> (selected := false, node: ^Node) {
	assert(class != nil)

	if inspector_state == .Change {
		return 
	}

	for member, i in Available_Types {
		rec := rl.Rectangle {
			x = size_window_width - size_inspector_width + 5,
			y = f32(60 + 30 * i32(i)), 
			width = size_inspector_width / 2,
			height = 25,
		}
		if rl.CheckCollisionPointRec(mouse_pos, rec) {
			type := Available_Types[i]
			node := init_member_defined(class, "", type, {i32(mouse_pos.x), i32(mouse_pos.y)})
			return true, node
		}
	}
	return 
}

@(private = "file")
select_new_function :: proc(class: ^Class, inspector_state: Inspector_State, mouse_pos: [2]f32) -> (selected := false, node: ^Node) {
	assert(class != nil)

	if inspector_state == .Change {
		return
	}

	for func, i in Available_Functions {
		rec := rl.Rectangle {
			x = size_window_width - size_inspector_width + 5,
			y = f32(90 + 30 * i32(i + len(Available_Types))), 
			width = size_inspector_width / 2,
			height = 25,
		}
		if rl.CheckCollisionPointRec(mouse_pos, rec) {
			type := Available_Functions[i]
			new_node := add_function_defined(class, type, {i32(mouse_pos.x), i32(mouse_pos.y)})
			return true, new_node
		}
	}
	return
}

@(private = "file")
select_member :: proc(class: ^Class, mouse_pos: [2]f32) -> (selected := false, node: ^Node, type := Selection_Type.None) {
	assert(class != nil)

	for member in class.members {
		rec := rl.Rectangle {
			x      = f32(member.node.pos.x),
			y      = f32(member.node.pos.y),
			width  = f32(member.size.x),
			height = f32(member.size.y),
		}
		if rl.CheckCollisionPointRec(mouse_pos, rec) {
			member_pos := node_get_member_pos_f32(member)
			if rl.CheckCollisionPointCircle(mouse_pos, member_pos, size_member_output) {
				return true, member, .Member_Out
			}
			return true, member, .Whole_Member
		}
	}
	return
}

@(private = "file")
select_function :: proc(class: ^Class, mouse_pos: [2]f32) -> (selected := false, node: ^Node, type := Selection_Type.None) {
	assert(class != nil)
	for func in class.functions {
		rec := rl.Rectangle {
			x      = f32(func.pos.x),
			y      = f32(func.pos.y),
			width  = f32(func.size.x),
			height = f32(func.size.y),
		}

		if rl.CheckCollisionPointRec({f32(rl.GetMouseX()), f32(rl.GetMouseY())}, rec) {
			input_pos := node_get_input_in_pos_f32(func, 0)
			exec_in_pos := node_get_exec_in_pos_f32(func)
			exec_out_pos := node_get_exec_out_pos_f32(func)

			if func.input_count > 0 && rl.CheckCollisionPointCircle(mouse_pos, input_pos, size_func_exec) {
				return true, func, .Function_Input
			} else if func.exec_in_count == 1 && rl.CheckCollisionPointCircle(mouse_pos, exec_in_pos, size_func_exec) {
				return true, func, .Exec_In
			} else if func.exec_out_count == 1 && rl.CheckCollisionPointCircle(mouse_pos, exec_out_pos, size_func_exec) {
				return true, func, .Exec_Out
			}
			return true, func, .Whole_Node
		}
	}
	return
}

@(private = "file")
select_inspector :: proc(mouse_pos: [2]f32) -> (selected: bool, new_state: Selection_Type) {
	rec := rl.Rectangle {
		x      = offset_inspector_edit,
		y      = 90,
		width  = 60,
		height = 25,
	}
	if rl.CheckCollisionPointRec({f32(rl.GetMouseX()), f32(rl.GetMouseY())}, rec) {
		return true, .Change_Name
	}

	rec = rl.Rectangle {
		x      = offset_inspector_edit,
		y      = 120,
		width  = 60,
		height = 25,
	}
	if rl.CheckCollisionPointRec({f32(rl.GetMouseX()), f32(rl.GetMouseY())}, rec) {
		return true, .Change_Value
	}

	rec = rl.Rectangle {
		x      = size_window_width - size_inspector_width,
		y      = 0,
		width  = size_inspector_width,
		height = size_window_height,
	}
	if rl.CheckCollisionPointRec({f32(rl.GetMouseX()), f32(rl.GetMouseY())}, rec) {
		return true, .Inspector
	}
	return false, .Whole_Node
}

@(private)
input_select :: proc(class: ^Class, app_input_ctx: ^App_Input_Ctx) {
	assert(class != nil)
	assert(app_input_ctx != nil)

	mouse_pos := [2]f32{f32(rl.GetMouseX()), f32(rl.GetMouseY())}

	selected, new_node := select_new_member(class, app_input_ctx.inspector_state, mouse_pos)
	if selected {
		app_input_ctx.select_type     = .Member_Add
		app_input_ctx.inspector_state = .Change
		app_input_ctx.selected_node   = new_node
		return
	}

	selected, new_node = select_new_function(class, app_input_ctx.inspector_state, mouse_pos)
	if selected {
		app_input_ctx.select_type     = .Function_Add
		app_input_ctx.inspector_state = .Add
		app_input_ctx.selected_node   = new_node
		return
	}

	select_type: Selection_Type
	selected, new_node, select_type = select_member(class, mouse_pos)
	if selected {
		app_input_ctx.select_type     = select_type
		app_input_ctx.inspector_state = .Change
		app_input_ctx.selected_node   = new_node
		return
	}

	selected, new_node, select_type = select_function(class, mouse_pos)
	if selected {
		app_input_ctx.select_type     = select_type
		app_input_ctx.inspector_state = .Add
		app_input_ctx.selected_node   = new_node
		return
	}

	selected, select_type = select_inspector(mouse_pos)
	if selected && app_input_ctx.inspector_state == .Change {
		app_input_ctx.select_type = select_type
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
	#partial switch app_input_ctx.select_type {
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
	}
}

@(private = "file")
change_name :: proc(node: ^Node) {
	assert(node != nil)
	if rl.IsKeyPressed(.BACKSPACE) {
		node.variant.(^Variable).name = node.variant.(^Variable).name[:len(node.variant.(^Variable).name)-1]
	}
	node.variant.(^Variable).name = add_letter(node.variant.(^Variable).name)
	variable_recalculate_width(node)
}

@(private = "file")
change_value :: proc(node: ^Node) {
	assert(node != nil)
	if rl.IsKeyPressed(.BACKSPACE) {
		node.variant.(^Variable).value = node.variant.(^Variable).name[:len(node.variant.(^Variable).value)-1]
	}
	node.variant.(^Variable).value = add_letter(node.variant.(^Variable).value)
}

@(private = "file")
add_letter :: proc(str: string) -> string {
	if rl.IsKeyDown(.LEFT_SHIFT) || rl.IsKeyDown(.RIGHT_SHIFT){
		switch {
			case rl.IsKeyPressed(.A): {return fmt.aprint(str, "A", sep = "")}
			case rl.IsKeyPressed(.B): {return fmt.aprint(str, "B", sep = "")}
			case rl.IsKeyPressed(.C): {return fmt.aprint(str, "C", sep = "")}
			case rl.IsKeyPressed(.D): {return fmt.aprint(str, "D", sep = "")}
			case rl.IsKeyPressed(.E): {return fmt.aprint(str, "E", sep = "")}
			case rl.IsKeyPressed(.F): {return fmt.aprint(str, "F", sep = "")}
			case rl.IsKeyPressed(.G): {return fmt.aprint(str, "G", sep = "")}
			case rl.IsKeyPressed(.H): {return fmt.aprint(str, "H", sep = "")}
			case rl.IsKeyPressed(.I): {return fmt.aprint(str, "I", sep = "")}
			case rl.IsKeyPressed(.J): {return fmt.aprint(str, "J", sep = "")}
			case rl.IsKeyPressed(.K): {return fmt.aprint(str, "K", sep = "")}
			case rl.IsKeyPressed(.L): {return fmt.aprint(str, "L", sep = "")}
			case rl.IsKeyPressed(.M): {return fmt.aprint(str, "M", sep = "")}
			case rl.IsKeyPressed(.N): {return fmt.aprint(str, "N", sep = "")}
			case rl.IsKeyPressed(.O): {return fmt.aprint(str, "O", sep = "")}
			case rl.IsKeyPressed(.P): {return fmt.aprint(str, "P", sep = "")}
			case rl.IsKeyPressed(.Q): {return fmt.aprint(str, "Q", sep = "")}
			case rl.IsKeyPressed(.R): {return fmt.aprint(str, "R", sep = "")}
			case rl.IsKeyPressed(.S): {return fmt.aprint(str, "S", sep = "")}
			case rl.IsKeyPressed(.T): {return fmt.aprint(str, "T", sep = "")}
			case rl.IsKeyPressed(.U): {return fmt.aprint(str, "U", sep = "")}
			case rl.IsKeyPressed(.V): {return fmt.aprint(str, "V", sep = "")}
			case rl.IsKeyPressed(.W): {return fmt.aprint(str, "W", sep = "")}
			case rl.IsKeyPressed(.X): {return fmt.aprint(str, "X", sep = "")}
			case rl.IsKeyPressed(.Y): {return fmt.aprint(str, "Y", sep = "")}
			case rl.IsKeyPressed(.Z): {return fmt.aprint(str, "Z", sep = "")}
			case rl.IsKeyPressed(.MINUS): {return fmt.aprint(str, "_", sep = "")}
		}
	}
	switch {
		case rl.IsKeyPressed(.A): {return fmt.aprint(str, "a", sep = "")}
		case rl.IsKeyPressed(.B): {return fmt.aprint(str, "b", sep = "")}
		case rl.IsKeyPressed(.C): {return fmt.aprint(str, "c", sep = "")}
		case rl.IsKeyPressed(.D): {return fmt.aprint(str, "d", sep = "")}
		case rl.IsKeyPressed(.E): {return fmt.aprint(str, "e", sep = "")}
		case rl.IsKeyPressed(.F): {return fmt.aprint(str, "f", sep = "")}
		case rl.IsKeyPressed(.G): {return fmt.aprint(str, "g", sep = "")}
		case rl.IsKeyPressed(.H): {return fmt.aprint(str, "h", sep = "")}
		case rl.IsKeyPressed(.I): {return fmt.aprint(str, "i", sep = "")}
		case rl.IsKeyPressed(.J): {return fmt.aprint(str, "j", sep = "")}
		case rl.IsKeyPressed(.K): {return fmt.aprint(str, "k", sep = "")}
		case rl.IsKeyPressed(.L): {return fmt.aprint(str, "l", sep = "")}
		case rl.IsKeyPressed(.M): {return fmt.aprint(str, "m", sep = "")}
		case rl.IsKeyPressed(.N): {return fmt.aprint(str, "n", sep = "")}
		case rl.IsKeyPressed(.O): {return fmt.aprint(str, "o", sep = "")}
		case rl.IsKeyPressed(.P): {return fmt.aprint(str, "p", sep = "")}
		case rl.IsKeyPressed(.Q): {return fmt.aprint(str, "q", sep = "")}
		case rl.IsKeyPressed(.R): {return fmt.aprint(str, "r", sep = "")}
		case rl.IsKeyPressed(.S): {return fmt.aprint(str, "s", sep = "")}
		case rl.IsKeyPressed(.T): {return fmt.aprint(str, "t", sep = "")}
		case rl.IsKeyPressed(.U): {return fmt.aprint(str, "u", sep = "")}
		case rl.IsKeyPressed(.V): {return fmt.aprint(str, "v", sep = "")}
		case rl.IsKeyPressed(.W): {return fmt.aprint(str, "w", sep = "")}
		case rl.IsKeyPressed(.X): {return fmt.aprint(str, "x", sep = "")}
		case rl.IsKeyPressed(.Y): {return fmt.aprint(str, "y", sep = "")}
		case rl.IsKeyPressed(.Z): {return fmt.aprint(str, "z", sep = "")}
		case rl.IsKeyPressed(.KP_1): {return fmt.aprint(str, "1", sep = "")}
		case rl.IsKeyPressed(.KP_2): {return fmt.aprint(str, "2", sep = "")}
		case rl.IsKeyPressed(.KP_3): {return fmt.aprint(str, "3", sep = "")}
		case rl.IsKeyPressed(.KP_4): {return fmt.aprint(str, "4", sep = "")}
		case rl.IsKeyPressed(.KP_5): {return fmt.aprint(str, "5", sep = "")}
		case rl.IsKeyPressed(.KP_6): {return fmt.aprint(str, "6", sep = "")}
		case rl.IsKeyPressed(.KP_7): {return fmt.aprint(str, "7", sep = "")}
		case rl.IsKeyPressed(.KP_8): {return fmt.aprint(str, "8", sep = "")}
		case rl.IsKeyPressed(.KP_9): {return fmt.aprint(str, "9", sep = "")}
		case rl.IsKeyPressed(.KP_0): {return fmt.aprint(str, "0", sep = "")}
		case rl.IsKeyPressed(.ONE):   {return fmt.aprint(str, "1", sep = "")}
		case rl.IsKeyPressed(.TWO):   {return fmt.aprint(str, "2", sep = "")}
		case rl.IsKeyPressed(.THREE): {return fmt.aprint(str, "3", sep = "")}
		case rl.IsKeyPressed(.FOUR):  {return fmt.aprint(str, "4", sep = "")}
		case rl.IsKeyPressed(.FIVE):  {return fmt.aprint(str, "5", sep = "")}
		case rl.IsKeyPressed(.SIX):   {return fmt.aprint(str, "6", sep = "")}
		case rl.IsKeyPressed(.SEVEN): {return fmt.aprint(str, "7", sep = "")}
		case rl.IsKeyPressed(.EIGHT): {return fmt.aprint(str, "8", sep = "")}
		case rl.IsKeyPressed(.NINE):  {return fmt.aprint(str, "9", sep = "")}
		case rl.IsKeyPressed(.ZERO):  {return fmt.aprint(str, "0", sep = "")}
	}
	return str
}
