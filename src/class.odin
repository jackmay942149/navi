package src

import "core:strings"

Class :: struct {
	name:      string,
	parent:    string,
	members:   []Variable,
	functions: []Function,
}

class_declare_begin :: proc(file: ^File_Context, class: ^Class) -> (out: string) {
	assert(file != nil)
	assert(class != nil)
	out_builder: strings.Builder
	strings.builder_init(&out_builder)
	defer strings.builder_destroy(&out_builder)

	for i in 0..<file.indent_lvl * 2 {
		strings.write_string(&out_builder, " ")
	}
	file.indent_lvl += 1

	strings.write_string(&out_builder, "public class ")
	strings.write_string(&out_builder, class.name)
	strings.write_string(&out_builder, " : ")
	strings.write_string(&out_builder, class.parent)
	strings.write_string(&out_builder, " {")

  out = strings.to_string(out_builder)
	return out
}

class_declare_end :: proc(file: ^File_Context) -> (out: string) {
	assert(file != nil)
	assert(file.indent_lvl > 0)
	out_builder: strings.Builder
	strings.builder_init(&out_builder) 
	defer strings.builder_destroy(&out_builder)
	
	file.indent_lvl -= 1
	for i in 0..<file.indent_lvl * 2 {
		strings.write_string(&out_builder, " ")
	}

	strings.write_string(&out_builder, "}")

  out = strings.to_string(out_builder)
	return out
}

