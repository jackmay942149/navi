package src

Split :: struct {
	variable:     ^Variable,
	linked_funcs: [dynamic]^Function,
	using node:   Node,
}

split_add :: proc(class: ^Class) {
	assert(class != nil)
	split := new(Split)
	assert(split != nil)

	append(&class.splits, split)

	split.size.x = 100
	split.size.y = 100
	split.variant = split
}
