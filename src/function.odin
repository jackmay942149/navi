package src

import str "core:strings"

Function :: struct {
	name, directive:     string,
	type:                FunctionType,
	output:              ^Variable,
	using node:          Node,
	inputs:              []^Variable,
	exec_ins, exec_outs: []^Function,
	input_count, exec_in_count, exec_out_count: int,
}

FunctionType :: enum {
	Standard,
	Template,
	Binary,
}

@(private)
function_call :: proc(file: ^File_Context, func: ^Function) -> (out: string) {
	assert(file != nil)
	assert(func != nil)
	out_builder: str.Builder
	str.builder_init(&out_builder) 

	// Indent
	for i in 0..<file.indent_lvl * 2 {
		str.write_string(&out_builder, " ")
	}

	// Add return value
	if func.output != nil {
		str.write_string(&out_builder, string(func.output.name))
		str.write_string(&out_builder, " = ")
	}

	switch func.type {
		case .Standard: function_call_standard(&out_builder, func)
		case .Template: function_call_template(&out_builder, func)
		case .Binary: function_call_binary(&out_builder, func)
	}

  out = str.to_string(out_builder)
	return out
}

@(private)
function_call_standard :: proc(builder: ^str.Builder, func: ^Function) {
	assert(builder != nil)
	assert(func != nil)

	// Call function
	str.write_string(builder, func.name)
	str.write_string(builder, "(")

	// Add inputs
	for var, i in func.inputs {
		if var != nil {
			if i != 0 {
				str.write_string(builder, ", ")
				if var.is_member {
					str.write_string(builder, string(var.name))
				} else {
					str.write_string(builder, variable_as_value(var))
				}
			} else {
				if var.is_member {
					str.write_string(builder, string(var.name))
				} else {
					str.write_string(builder, variable_as_value(var))
				}
			}
		}
	}
	str.write_string(builder, ");")
}

@(private)
function_call_template :: proc(builder: ^str.Builder, func: ^Function){
	assert(builder != nil)
	assert(func != nil)
	assert(func.output != nil)

	// Call function
	str.write_string(builder, func.name)
	str.write_string(builder, "<")
	str.write_string(builder, Variable_Type_As_String[func.output.type])
	str.write_string(builder, ">")
	str.write_string(builder, "(")
	
	// Add inputs
	for var, i in func.inputs {
		if var != nil {
			if i != 0 {
				str.write_string(builder, ", ")
				if var.is_member {
					str.write_string(builder, string(var.name))
				} else {
					str.write_string(builder, variable_as_value(var))
				}
			} else {
				if var.is_member {
					str.write_string(builder, string(var.name))
				} else {
					str.write_string(builder, variable_as_value(var))
				}
			}
		}
	}
	str.write_string(builder, ");")
}

@(private)
function_call_binary :: proc(builder: ^str.Builder, func: ^Function) {
	assert(builder != nil)
	assert(func != nil)
	assert(func.input_count == 2)
	assert(func.inputs != nil)
	assert(len(func.inputs) > 1)
	str.write_string(builder, string(func.inputs[0].name))
	str.write_string(builder, " ")
	str.write_string(builder, func.name)
	str.write_string(builder, " ")
	str.write_string(builder, string(func.inputs[1].name))
	str.write_string(builder, ";")
}

@(private)
function_declare_begin :: proc(file: ^File_Context, func: ^Function) -> (out: string) {
	assert(file != nil)
	assert(func != nil)
	out_builder: str.Builder
	str.builder_init(&out_builder) 

	for i in 0..<file.indent_lvl * 2 {
		str.write_string(&out_builder, " ")
	}
	file.indent_lvl += 1

	if func.output == nil {
		str.write_string(&out_builder, "void")
  } else {
  	str.write_string(&out_builder, Variable_Type_As_String[func.output.type])
  }
	str.write_string(&out_builder, " ")
	str.write_string(&out_builder, func.name)
	str.write_string(&out_builder, "() {")

  out = str.to_string(out_builder)
	return out
}

@(private)
function_declare_end :: proc(file: ^File_Context) -> (out: string) {
	assert(file != nil)
	assert(file.indent_lvl > 0)
	out_builder: str.Builder
	str.builder_init(&out_builder) 
	
	file.indent_lvl -= 1
	for i in 0..<file.indent_lvl * 2 {
		str.write_string(&out_builder, " ")
	}

	str.write_string(&out_builder, "}")

  out = str.to_string(out_builder)
	return out
}

@(private)
function_directive :: proc(func: ^Function) -> (out: string) {
	assert(func != nil)
	out_builder: str.Builder
	str.builder_init(&out_builder) 

	str.write_string(&out_builder, "using ")
	str.write_string(&out_builder, func.directive)
	str.write_string(&out_builder, ";")

  out = str.to_string(out_builder)
	return out
}

