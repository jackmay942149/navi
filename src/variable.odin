package src

import "core:strings"

Variable :: struct {
	name:   string,
	type:   string,
	fields: []Variable,
	value:  string,
}

variable_declare :: proc(file: ^File_Context, var: ^Variable) -> (out: string) {
	assert(file != nil)
	out_builder: strings.Builder
	strings.builder_init(&out_builder) 
	defer strings.builder_destroy(&out_builder)

	for i in 0..<file.indent_lvl * 2 {
		strings.write_string(&out_builder, " ")
	}

	strings.write_string(&out_builder, var.type)
	strings.write_string(&out_builder, " ")
	strings.write_string(&out_builder, var.name)
	strings.write_string(&out_builder, " = ")
	if var.type == "string" {
		strings.write_string(&out_builder, "\"")
		strings.write_string(&out_builder, var.value)
		strings.write_string(&out_builder, "\";")
  }

  out = strings.to_string(out_builder)
	return out
}
