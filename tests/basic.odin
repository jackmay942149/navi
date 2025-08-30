package tests

import "../src"
import test "core:testing"

@(test)
basic_main :: proc(t: ^test.T) {
	foo           := src.init_class("Basic", "MonoBehaviour")

	hello         := src.init_member(&foo, "Hello", .String, "Hello World")
	one           := src.init_member(&foo, "One", .Int, "1")

	debug_log     := src.add_function(&foo, "Debug.Log", "UnityEngine", 1, 1, 1) 
	debug_log_one := src.add_function(&foo, "Debug.Log", "UnityEngine", 1, 1, 1) 
	start         := src.add_function(&foo, "Start", "UnityEngine", 0, 0, 1) 
	awake         := src.add_function(&foo, "Awake", "UnityEngine", 0, 0, 1) 

	src.link_function(start, debug_log)
	src.link_variable(hello, debug_log)

	src.save_class(&foo)
	src.destroy_class(&foo)
}
