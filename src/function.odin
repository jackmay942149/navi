package src

import "core:strings"

Function :: struct {
	name:           string,
	output:         Maybe(Variable),
	input_count:    int,
	inputs:         []^Variable,
	directive:      string,
	exec_in_count:  int,
	exec_ins:       []^Function,
	exec_out_count: int,
	exec_outs:      []^Function,
	node:           NodeInfo,
}

@(private)
function_call :: proc(file: ^File_Context, func: ^Function) -> (out: string) {
	assert(file != nil)
	assert(func != nil)
	out_builder: strings.Builder
	strings.builder_init(&out_builder) 
	
	for i in 0..<file.indent_lvl * 2 {
		strings.write_string(&out_builder, " ")
	}

	strings.write_string(&out_builder, func.name)
	strings.write_string(&out_builder, "(")
	if func.inputs[0] != nil {
		strings.write_string(&out_builder, string(func.inputs[0].name))
	}
	strings.write_string(&out_builder, ");")

  out = strings.to_string(out_builder)
	return out
}

@(private)
function_declare_begin :: proc(file: ^File_Context, func: ^Function) -> (out: string) {
	assert(file != nil)
	assert(func != nil)
	out_builder: strings.Builder
	strings.builder_init(&out_builder) 

	for i in 0..<file.indent_lvl * 2 {
		strings.write_string(&out_builder, " ")
	}
	file.indent_lvl += 1

	if func.output == nil {
		strings.write_string(&out_builder, "void")
  } else {
  	strings.write_string(&out_builder, Type_As_String[func.output.(Variable).type])
  }
	strings.write_string(&out_builder, " ")
	strings.write_string(&out_builder, func.name)
	strings.write_string(&out_builder, "() {")

  out = strings.to_string(out_builder)
	return out
}

@(private)
function_declare_end :: proc(file: ^File_Context) -> (out: string) {
	assert(file != nil)
	assert(file.indent_lvl > 0)
	out_builder: strings.Builder
	strings.builder_init(&out_builder) 
	
	file.indent_lvl -= 1
	for i in 0..<file.indent_lvl * 2 {
		strings.write_string(&out_builder, " ")
	}

	strings.write_string(&out_builder, "}")

  out = strings.to_string(out_builder)
	return out
}

@(private)
function_directive :: proc(func: ^Function) -> (out: string) {
	assert(func != nil)
	out_builder: strings.Builder
	strings.builder_init(&out_builder) 

	strings.write_string(&out_builder, "using ")
	strings.write_string(&out_builder, func.directive)
	strings.write_string(&out_builder, ";")

  out = strings.to_string(out_builder)
	return out
}

