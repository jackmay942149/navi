package main

import "./src"
import "core:fmt"

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

debug_log := src.Function {
	name = "Debug.Log",
	output = void,
	input = {&hello},
	directive = "UnityEngine",
}

start := src.Function {
	name = "Start",
	output = void,
	input = nil,
	directive = "UnityEngine"
}

foo := src.Class {
	name = "Foo",
	parent = "MonoBehaviour"
}

file: src.File_Context

main :: proc() {
	src.file_add(src.function_directive(&debug_log))
	src.file_add(src.class_declare_begin(&file, &foo))
	src.file_add(src.function_declare_begin(&file, &start))
	src.file_add(src.variable_declare(&file, &hello))
	src.file_add(src.function_call(&file, &debug_log))
	src.file_add(src.function_declare_end(&file))
	src.file_add(src.class_declare_end(&file))
}
