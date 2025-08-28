package src

import "core:fmt"

File_Context :: struct {
	indent_lvl: uint
}

file_add_string :: proc(line: string) {
	fmt.println(line)
}

file_add_strings :: proc(strings: ^[]string) {
	for s in strings {
		if s != "" {
			fmt.println(s)
		}
	}
}

file_add_class :: proc(class: ^Class) {
	assert(class != nil)
	file: File_Context

	// Add using declarations
	req_declares := make([]string, len(class.functions))
	for &func, i in class.functions {
		if func.directive != "" {
			// Check to see if declare is already given
			decl_to_add := function_directive(func)
			for decl in req_declares {
				if decl == decl_to_add {
					break
				}
				// Add if not
				req_declares[i] = function_directive(func)
			}
		}
	}
	file_add_strings(&req_declares)

	// Initiate class
	file_add_string(class_declare_begin(&file, class))
	defer file_add_string(class_declare_end(&file))

	// Add members
	for &m in class.members {
		file_add_string(variable_declare(&file, m))
	}

	// Add functions
	for &func in class.functions {
		if func.exec_in_count == 0 {
			file_add_string(function_declare_begin(&file, func))
			defer file_add_string(function_declare_end(&file))

			// Recursively move through linked list of functions
			temp := func
			for true {
				file_add_string(function_call(&file, temp.exec_outs[0]))
				temp = temp.exec_outs[0]
				if temp.exec_out_count == 0 {
					break  
				} else if temp.exec_outs[0] == nil {
					break
				}
			}
		}
	}
}
