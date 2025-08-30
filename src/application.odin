package src

import rl "vendor:raylib"

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
	rl.EndDrawing()
}

/*
	src.application_init()
	for src.application_should_close() {
		src.application_update()
	}
*/
