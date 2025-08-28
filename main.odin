package main

import "./src"
import "core:fmt"

hello:     src.Variable
one:     src.Variable
start:     src.Function
awake:     src.Function
debug_log: src.Function
debug_log_one: src.Function
file:      src.File_Context

main :: proc() {
	hello = src.Variable {
		name = "Hello",
		type = "string",
		fields = nil,
		value = "Hello World"
	}

	one = src.Variable {
		name = "One",
		type = "int",
		fields = nil,
		value = "1"
	}

	debug_log = src.Function {
		name = "Debug.Log",
		input = {&hello},
		directive = "UnityEngine",
		exec_in_count = 1,
		exec_ins = {&start},
		exec_out_count = 1,
		exec_outs = {&debug_log_one}
	}

	debug_log_one = src.Function {
		name = "Debug.Log",
		input = {&one},
		directive = "UnityEngine",
		exec_in_count = 1,
		exec_ins = {&debug_log},
		exec_out_count = 1,
		exec_outs = {nil}
	}

	start = src.Function {
		name = "Start",
		directive = "UnityEngine",
		exec_out_count = 1,
		exec_outs = {&debug_log}
	}

	awake = src.Function {
		name = "Awake",
		directive = "System.Collections",
		exec_out_count = 1,
		exec_outs = {&debug_log}
	}

	foo := src.Class {
		name = "Foo",
		parent = "MonoBehaviour",
		members = {&hello, &one},
		functions = {&start, &debug_log, &awake, &debug_log_one}
	}
	src.file_add_class(&foo)
}
