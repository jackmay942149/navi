package src

init_class :: proc(name: string, parent: string) -> (class: Class) {
	class.name      = name
	class.parent    = parent
	class.functions = make([dynamic]^Function, 0)
	class.members   = make([dynamic]^Variable, 0)

	return class
}

init_member :: proc(class: ^Class, name: string, type: Type, value: string) -> (var: ^Variable){
	assert(class != nil)

	var = new(Variable)
	assert(var != nil)

	var.name = name
	var.type = Type_As_String[type]
	var.value = value

	append(&class.members, var)
	return var
}

set_member :: proc() {
	
}

add_function :: proc(class: ^Class, name, directive: string, input_count, exec_in_count, exec_out_count: int) -> (func: ^Function) {
	assert(class != nil)

	func = new(Function)
	assert(func != nil)

	func.name = name
	func.directive = directive
	func.input_count = input_count
	func.inputs = make([]^Variable, input_count)
	func.exec_in_count = exec_in_count
	func.exec_ins = make([]^Function, exec_in_count)
	func.exec_out_count = exec_out_count
	func.exec_outs = make([]^Function, exec_out_count)

	append(&class.functions, func)
	return func
}

link_function :: proc(from: ^Function, to: ^Function) {
	assert(from != nil)
	assert(to != nil)

	from.exec_outs[0] = to
	to.exec_ins[0] = from
}

link_variable :: proc(var: ^Variable, func: ^Function) {
	assert(var != nil)
	assert(func != nil)

	func.inputs[0] = var
}

save_class :: proc(class: ^Class) {
	file_add_class(class)
}
