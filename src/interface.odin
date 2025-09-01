package src

import "core:mem"

init_class :: proc(name: string, parent: string, allocator := context.allocator) -> (class: Class) {
	context.allocator = allocator
	class.name      = name
	class.parent    = parent
	class.functions = make([dynamic]^Function, 0, 1)
	class.members   = make([dynamic]^Variable, 0, 1)
	assert(class.functions != nil)
	assert(class.members != nil)
	return class
}

init_member :: proc(class: ^Class, name: cstring, type: Type, value: string, pos: [2]i32, allocator := context.allocator) -> (var: ^Variable) {
	context.allocator = allocator
	assert(class != nil)
	assert(class.members != nil)

	var = new(Variable)
	assert(var != nil)

	var.name = name
	var.type = Type_As_String[type]
	var.value = value
	var.node.pos = pos

	append(&class.members, var)
	return var
}

set_member :: proc() {
	
}

add_function :: proc(class: ^Class, name, directive: string, input_count, exec_in_count, exec_out_count: int, allocator := context.allocator) -> (func: ^Function) {
	context.allocator = allocator
	assert(class != nil)
	assert(class.functions != nil)

	func = new(Function)
	assert(func != nil)
	
	func.name = name
	func.directive = directive
	func.input_count = input_count

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

link_variable :: proc(var: ^Variable, func: ^Function) {
	assert(var != nil)
	assert(func != nil)
	assert(func.inputs != nil)
	assert(len(func.inputs) > 0)

	func.inputs[0] = var
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
