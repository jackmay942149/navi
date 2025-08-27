package src

import "core:strings"

Function :: struct {
	name:           string,
	output:         Variable,
	input:          []^Variable,
	directive:      string,
	exec_in_count:  int,
	exec_ins:       []Function,
	exec_out_count: int,
	exec_outs:      []Function,
}

function_call :: proc(file: ^File_Context, func: ^Function) -> (out: string) {
	assert(file != nil)
	out_builder: strings.Builder
	strings.builder_init(&out_builder) 
	defer strings.builder_destroy(&out_builder)
	
	for i in 0..<file.indent_lvl * 2 {
		strings.write_string(&out_builder, " ")
	}

	strings.write_string(&out_builder, func.name)
	strings.write_string(&out_builder, "(")
	strings.write_string(&out_builder, func.input[0].name)
	strings.write_string(&out_builder, ");")

  out = strings.to_string(out_builder)
	return out
}

function_declare_begin :: proc(file: ^File_Context, func: ^Function) -> (out: string) {
	assert(file != nil)
	out_builder: strings.Builder
	strings.builder_init(&out_builder) 
	defer strings.builder_destroy(&out_builder)

	for i in 0..<file.indent_lvl * 2 {
		strings.write_string(&out_builder, " ")
	}
	file.indent_lvl += 1

	strings.write_string(&out_builder, func.output.type)
	strings.write_string(&out_builder, " ")
	strings.write_string(&out_builder, func.name)
	strings.write_string(&out_builder, "() {")

  out = strings.to_string(out_builder)
	return out
}

function_declare_end :: proc(file: ^File_Context) -> (out: string) {
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

