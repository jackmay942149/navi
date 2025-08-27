package src

import "core:fmt"

File_Context :: struct {
	indent_lvl: uint
}

file_add ::proc(line: string) {
	fmt.println(line)
}
