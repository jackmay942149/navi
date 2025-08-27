package tests

import "../src"
import test "core:testing"
import "core:fmt"

@(private = "file")
hello := src.Variable {
	name = "Hello",
	type = "string",
	fields = nil,
	value = "Hello World"
}

@(private = "file")
void := src.Variable {
	name = "",
	type = "void",
	fields = nil,
	value = "",
}

@(private = "file")
debug_log := src.Function {
	name = "Debug.Log",
	output = void,
	input = {&hello},
	directive = "UnityEngine",
}

@(private = "file")
start := src.Function {
	name = "Start",
	output = void,
	input = nil,
	directive = "UnityEngine"
}

@(private = "file")
foo := src.Class {
	name = "Foo",
	parent = "MonoBehaviour"
}

@(private = "file")
file: src.File_Context

@(test)
debug_log_main :: proc(t: ^test.T) {
	exp1 := "using UnityEngine;"
	exp2 := "public class Foo : MonoBehaviour {"
	exp3 := "  void Start() {"
	exp4 := "    string Hello = \"Hello World\";"
	exp5 := "    Debug.Log(Hello);"
	exp6 := "  }"
	exp7 := "}"

	res1 :=  src.function_directive(&debug_log)
	test.expect_value(t, res1, exp1)

	res2 :=  src.class_declare_begin(&file, &foo)
	test.expect_value(t, res2, exp2)

	res3 :=  src.function_declare_begin(&file, &start)
	test.expect_value(t, res3, exp3)

	res4 :=  src.variable_declare(&file, &hello)
	test.expect_value(t, res4, exp4)

	res5 :=  src.function_call(&file, &debug_log)
	test.expect_value(t, res5, exp5)

	res6 :=  src.function_declare_end(&file)
	test.expect_value(t, res6, exp6)

	res7 :=  src.class_declare_end(&file)
	test.expect_value(t, res7, exp7)
}
