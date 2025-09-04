package src

import str "core:strings"
import rl  "vendor:raylib"

application_init :: proc(width, height: i32, title: cstring) {
	rl.InitWindow(width, height, title)
	return
}

application_should_close :: proc() -> bool {
	return rl.WindowShouldClose()
}

application_update :: proc(class: ^Class) {
	rl.BeginDrawing()
	for func in class.functions {
		rl.DrawRectangle(func.node.pos.x, func.node.pos.y, 100, 100, rl.GRAY)
	}
	for member in class.members {
		rl.DrawRectangle(member.node.pos.x, member.node.pos.y, 100, 100, rl.RED)
		csr := str.clone_to_cstring(member.name, context.temp_allocator)
		rl.DrawText(csr, member.node.pos.x, member.node.pos.y, 12, rl.GRAY)
		free_all(context.temp_allocator)
	}
	rl.EndDrawing()
	application_poll_input(class)
}

application_close :: proc() {
	rl.CloseWindow()	
}

@(private)
application_poll_input :: proc(class: ^Class) {
	if rl.IsKeyPressed(.S) {
		_ = init_member_new(class, "Hello", .String, "Hello World", {rl.GetMouseX(), rl.GetMouseY()})
	}
}
