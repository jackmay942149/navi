package src

import str "core:strings"

Variable :: struct {
	name:       string,
	parent_name: string,
	type:       Variable_Type,
	fields:     []^Variable,
	value:      string,
	using node: Node,
	is_member:  bool,
	is_split:   bool,
}

@(private)
variable_declare :: proc(file: ^File_Context, var: ^Variable) -> (out: string) {
	assert(file != nil)
	out_builder: str.Builder
	str.builder_init(&out_builder) 

	for i in 0..<file.indent_lvl * 2 {
		str.write_string(&out_builder, " ")
	}

	str.write_string(&out_builder, Variable_Type_As_String[var.type])
	str.write_string(&out_builder, " ")
	str.write_string(&out_builder, string(var.name))
	// if var.type == .String || var.type == .Float || var.type == .Int {
	if var.value != "" {
		str.write_string(&out_builder, " = ") // TODO: is for vec, and add function for partial switch
		str.write_string(&out_builder, variable_as_value(var))
	}

	str.write_string(&out_builder, ";")
  out = str.to_string(out_builder)
	return out
}

variable_as_value :: proc(var: ^Variable, allocator := context.allocator) -> string {
	context.allocator = allocator
	assert(var != nil)
	#partial switch var.type {
		case .String: {
			out := []string {"\"", var.value, "\""}
			return str.concatenate(out)
		}
		case .Float: {
			if str.contains(var.value, ".") {
				out := []string {var.value, "f"}
				return str.concatenate(out)
			} else {
				out := []string {var.value, ".0f"}
				return str.concatenate(out)
			}
		}
		case .Int: {
	  	return var.value
	  }
  }
  return ""
}

variable_recalculate_width :: proc(node: ^Node) {
	node.size.x = size_member_w + i32(len(node.variant.(^Variable).name)) * size_character
}
