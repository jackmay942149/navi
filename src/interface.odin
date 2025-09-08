package src

import mem "core:mem"
import str "core:strings"

init_class :: proc(name: string, parent: string, allocator := context.allocator) -> (class: Class) {
	context.allocator = allocator
	class.name      = name
	class.parent    = parent
	class.functions = make([dynamic]^Function, 0, 1)
	class.members   = make([dynamic]^Variable, 0, 1)
	class.variables   = make([dynamic]^Variable, 0, 1)
	assert(class.functions != nil)
	assert(class.members != nil)
	assert(class.variables!= nil)
	return class
}

init_member :: proc {
	init_member_new,
	init_member_defined,
}

init_member_new :: proc(class: ^Class, name: string, type: Variable_Type, value: string, pos: [2]i32, allocator := context.allocator) -> (var: ^Variable) {
	context.allocator = allocator
	assert(class != nil)
	assert(class.members != nil)

	var = new(Variable)
	assert(var != nil)

	var.name = name
	var.type = type
	var.value = value
	var.node.pos = pos
	var.variant = var
	var.is_member = true

	append(&class.members, var)
	return var
}

init_member_defined :: proc(class: ^Class, name: string, def: Predefined_Type, pos: [2]i32, allocator := context.allocator) -> (var: ^Variable) {
	context.allocator = allocator
	assert(class != nil)
	var = init_member_new(class, name, def.type, "", pos)
	var.fields = make([]^Variable, len(def.fields))
	for member, i in def.fields {
		member_name := str.concatenate({var.name, ".", member.name})
		new := add_variable(class, member.type, name = member_name, value = "", pos = {})
		var.fields[i] = new
	} 
	return var
}

add_variable :: proc(class: ^Class, type: Variable_Type, value: string, pos: [2]i32, name := "", allocator := context.allocator) -> (var: ^Variable) {
	context.allocator = allocator
	assert(class != nil)
	assert(class.variables != nil)
	
	var = new(Variable)
	assert(var != nil)

	var.type = type
	var.name = name
	var.value = value
	var.node.pos = pos
	var.is_member = false

	append(&class.variables, var)
	return var
}

set_member :: proc() {
	
}

add_function :: proc {
	add_function_new,
	add_function_defined,
}

add_function_new :: proc(
class: ^Class,
name, directive: string,
type := FunctionType.Standard,
input_count, exec_in_count, exec_out_count: int,
position : [2]i32 = {0, 0},
allocator := context.allocator,
) -> (
func: ^Function) {
	context.allocator = allocator
	assert(class != nil)
	assert(class.functions != nil)

	func = new(Function)
	assert(func != nil)
	
	func.name = name
	func.directive = directive
	func.type = type
	func.input_count = input_count
	func.pos = position
	func.variant = func

	err: mem.Allocator_Error
	func.inputs, err = make([]^Variable, input_count)
	assert(err == nil)

	func.exec_in_count = exec_in_count
	func.exec_ins, err = make([]^Function,  exec_in_count)
	assert(err == nil)

	func.exec_out_count = exec_out_count
	func.exec_outs, err = make([]^Function,  exec_out_count)
	assert(err == nil)

	append(&class.functions, func)
	return func
}

add_function_defined :: proc(class: ^Class, def: Predefined_Function, position : [2]i32 = {0, 0}, allocator := context.allocator) -> (func: ^Function) {
	context.allocator = allocator
	using def
	return add_function_new(class, name, directive, type, input_count, exec_in_count, exec_out_count, position)
}

link_function :: proc(from: ^Function, to: ^Function) {
	assert(from != nil)
	assert(to != nil)
	assert(from.exec_outs != nil)
	assert(len(from.exec_outs) > 0)
	assert(to.exec_ins != nil)
	assert(len(to.exec_ins) > 0)

	from.exec_outs[0] = to
	to.exec_ins[0] = from
}

link_variable :: proc(var: ^Variable, func: ^Function, pos: int = 0) {
	assert(var != nil)
	assert(func != nil)
	assert(func.inputs != nil)
	assert(len(func.inputs) > pos)

	func.inputs[pos] = var
}

link_output :: proc(var: ^Variable, func: ^Function) {
	assert(var != nil)
	assert(func != nil)
	assert(func.output == nil)
	func.output = var
}

link_output_field :: proc(var: ^Variable, func: ^Function, pos: int) {
	assert(var != nil)
	assert(func != nil)
	assert(func.output == nil)
	func.output = var
}

save_class :: proc(class: ^Class) {
	assert(class != nil)
	file_add_class(class)
}

destroy_class :: proc(class: ^Class) {
	assert(class != nil)
	assert(class.members != nil)
	assert(class.functions != nil)

	for &member in class.members {
		assert(member != nil)
		free(member)
	}
	for &func in class.functions {
		assert(func != nil)
		delete(func.inputs)
		delete(func.exec_ins)
		delete(func.exec_outs)
		free(func)
	}
	delete(class.members)
	delete(class.functions)
}
