package src

Node :: struct {
	pos:   [2]i32,
	color: [3]i32,
	size:  [2]i32,
	variant: union{^Variable, ^Function},
}

node_move :: proc(node: ^Node, x,y : i32) {
	assert(node != nil)
	node.pos.x = x - node.size.x/2
	node.pos.y = y - node.size.y/2
	if x > size_window_width - size_inspector_width - node.size.x/2 {
		node.pos.x = size_window_width - size_inspector_width - node.size.x
	} else if x < node.size.x/2 {
		node.pos.x = 0
	}
	if node.pos.y < 0 {
		node.pos.y = 0
	} else if y > size_window_height - node.size.y/2 {
		node.pos.y = size_window_height - node.size.y
	}
}

node_get_member_pos_i32 :: proc(node: ^Node) -> (pos: [2]i32) {
	assert(node != nil)	
	return {node.pos.x + offset_member_out.x + i32(len(node.variant.(^Variable).name)) * size_character, node.pos.y + offset_member_out.y}
}

node_get_member_pos_f32 :: proc(node: ^Node) -> (pos: [2]f32) {
	assert(node != nil)	
	return {f32(node.pos.x + offset_member_out.x + i32(len(node.variant.(^Variable).name)) * size_character), f32(node.pos.y + offset_member_out.y)}
}

node_get_exec_in_pos_f32 :: proc(node: ^Node) -> (pos: [2]f32) {
	assert(node != nil)	
	return {f32(node.pos.x + offset_exec_in.x), f32(node.pos.y + offset_exec_in.y)}
}

node_get_exec_in_pos_i32 :: proc(node: ^Node) -> (pos: [2]i32) {
	assert(node != nil)	
	return {i32(node.pos.x + offset_exec_in.x), i32(node.pos.y + offset_exec_in.y)}
}

node_get_exec_out_pos_f32 :: proc(node: ^Node) -> (pos: [2]f32) {
	assert(node != nil)	
	return {f32(node.pos.x + offset_exec_out.x), f32(node.pos.y + offset_exec_out.y)}
}

node_get_exec_out_pos_i32 :: proc(node: ^Node) -> (pos: [2]i32) {
	assert(node != nil)	
	return {i32(node.pos.x + offset_exec_out.x), i32(node.pos.y + offset_exec_out.y)}
}

node_get_input_in_pos_f32 :: proc(node: ^Node, index: int) -> (pos: [2]f32) {
	assert(node != nil)	
	return {f32(node.pos.x + offset_func_in.x), f32(node.pos.y + offset_func_in.y)}
}

node_get_input_in_pos_i32 :: proc(node: ^Node, index: int) -> (pos: [2]i32) {
	assert(node != nil)	
	return {i32(node.pos.x + offset_func_in.x), i32(node.pos.y + offset_func_in.y + i32(20 * index))}
}

