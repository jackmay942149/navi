package tests

import "../src"
import test "core:testing"

hello := src.Variable {
	name = "Hello",
	type = "string",
	fields = nil,
	value = "Hello World"
}

void := src.Variable {
	name = "",
	type = "void",
	fields = nil,
	value = "",
}

@(test)
variable_declare_string :: proc(t: ^test.T) {
	file: src.File_Context
	res := src.variable_declare(&file, &hello)
	exp := "string Hello = \"Hello World\";"
	test.expect_value(t, res, exp)
}

@(test)
variable_declare_string_indented :: proc(t: ^test.T) {
	file: src.File_Context
	file.indent_lvl = 1
	res := src.variable_declare(&file, &hello)
	exp := "  string Hello = \"Hello World\";"
	test.expect_value(t, res, exp)
}

@(test)
function_call_debug_log :: proc(t: ^test.T) {
	file: src.File_Context
	debug_log := src.Function {
		name = "Debug.Log",
		output = void,
		input = {&hello},
		directive = "",
	}

	res := src.function_call(&file, &debug_log)
	exp := "Debug.Log(Hello);"
	test.expect_value(t, res, exp)
}

@(test)
function_declare_begin_start :: proc(t: ^test.T) {
	file: src.File_Context
	start := src.Function {
		name = "Start",
		output = void,
		input = nil,
		directive = ""
	}

	res := src.function_declare_begin(&file, &start)
	exp := "void Start() {"
	test.expect_value(t, res, exp)
}

@(test)
function_declare_end_indented_before :: proc(t: ^test.T) {
	file: src.File_Context
	file.indent_lvl = 1
	res := src.function_declare_end(&file)
	exp := "}"
	test.expect_value(t, res, exp)
}

@(test)
function_declare_end_indented_after :: proc(t: ^test.T) {
	file: src.File_Context
	file.indent_lvl = 2
	res := src.function_declare_end(&file)
	exp := "  }"
	test.expect_value(t, res, exp)
}

@(test)
class_declare_begin_start :: proc(t: ^test.T) {
	file: src.File_Context
	class := src.Class {
		name = "Foo",
		parent = "MonoBehaviour"
	}

	res := src.class_declare_begin(&file, &class)
	exp := "public class Foo : MonoBehaviour {"
	test.expect_value(t, res, exp)
}

@(test)
class_declare_end_indented_before :: proc(t: ^test.T) {
	file: src.File_Context
	file.indent_lvl = 1
	res := src.class_declare_end(&file)
	exp := "}"
	test.expect_value(t, res, exp)
}

@(test)
class_declare_end_indented_after :: proc(t: ^test.T) {
	file: src.File_Context
	file.indent_lvl = 2
	res := src.class_declare_end(&file)
	exp := "  }"
	test.expect_value(t, res, exp)
}
