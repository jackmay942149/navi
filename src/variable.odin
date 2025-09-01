package src

import str "core:strings"

Variable :: struct {
	name:   cstring,
	type:   Type,
	fields: []Variable,
	value:  string,
	node:   NodeInfo,
}

@(private)
variable_declare :: proc(file: ^File_Context, var: ^Variable) -> (out: string) {
	assert(file != nil)
	out_builder: str.Builder
	str.builder_init(&out_builder) 

	for i in 0..<file.indent_lvl * 2 {
		str.write_string(&out_builder, " ")
	}

	str.write_string(&out_builder, Type_As_String[var.type])
	str.write_string(&out_builder, " ")
	str.write_string(&out_builder, string(var.name))

	#partial switch var.type {
		case .String: {
			str.write_string(&out_builder, " = ")
			str.write_string(&out_builder, "\"")
			str.write_string(&out_builder, var.value)
			str.write_string(&out_builder, "\"")
		}
		case .Float: {
			str.write_string(&out_builder, " = ")
			str.write_string(&out_builder, var.value)
			if str.contains(var.value, ".") {
				str.write_string(&out_builder, "f")
			} else {
				str.write_string(&out_builder, ".0f")
			}
		}
		case .Int: {
			str.write_string(&out_builder, " = ")
	  	str.write_string(&out_builder, var.value)
	  }
  }

	str.write_string(&out_builder, ";")
  out = str.to_string(out_builder)
	return out
}
