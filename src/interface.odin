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

add_function :: proc() {
	
}

link_function :: proc() {
	
}

link_variable :: proc() {
	
}

save_class :: proc(class: ^Class) {
	file_add_class(class)
}
