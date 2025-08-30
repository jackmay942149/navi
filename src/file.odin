package src

import "core:os"
import "core:fmt"
import "core:strings"

File_Context :: struct {
	handle:     os.Handle,
	indent_lvl: uint,
}

file_init :: proc(file: ^File_Context, name: string) {
	assert(file != nil)
	temp := [?]string{"./", name, ".cs"}
	file_path := strings.concatenate(temp[:])
	defer delete(file_path)
	f, err := os.open(file_path, os.O_WRONLY | os.O_CREATE)
	if err != nil {
		fmt.println(err)
	}
	file.handle = f
}

file_close :: proc(file: ^File_Context) {
	assert(file != nil)
	err := os.close(file.handle)
	if err != nil {
		fmt.println(err)
	}
}

file_add_string :: proc(file: ^File_Context, line: string) {
	assert(file != nil)
	os.write_string(file.handle, line)
	os.write_string(file.handle, "\n")
}

file_add_strings :: proc(file: ^File_Context, strings: ^[]string) {
	for s in strings {
		if s != "" {
			file_add_string(file, s)
		}
	}
}

file_add_class :: proc(class: ^Class) {
	assert(class != nil)
	file: File_Context
	file_init(&file, class.name)
	defer file_close(&file)

	// Add using declarations
	req_declares := make([]string, len(class.functions))
	for &func, i in class.functions {
		if func.directive != "" {
			// Check to see if declare is already given
			decl_to_add := function_directive(func)
			for decl, j in req_declares {
				if decl == decl_to_add {
					break
				} else if j == len(req_declares) - 1{
					req_declares[i] = function_directive(func) // Add if not
				}
			}
		}
	}
	file_add_strings(&file, &req_declares)
	delete(req_declares)

	// Initiate class
	file_add_string(&file, class_declare_begin(&file, class))
	defer file_add_string(&file, class_declare_end(&file))

	// Add members
	for &m in class.members {
		file_add_string(&file, variable_declare(&file, m))
	}

	// Add functions
	for &func in class.functions {
		if func.exec_in_count == 0 {
			file_add_string(&file, function_declare_begin(&file, func))
			defer file_add_string(&file, function_declare_end(&file))

			// Recursively move through linked list of functions
			temp := func
			for len(temp.exec_outs) > 0 {
				if temp.exec_outs[0] == nil {
					break
				}
				file_add_string(&file, function_call(&file, temp.exec_outs[0]))
				temp = temp.exec_outs[0]
				if temp.exec_out_count == 0 {
					break  
				}
			}
		}
	}
}
