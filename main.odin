package main

import "./src"
import "core:fmt"

main :: proc() {
	foo           := src.init_class("Foo", "MonoBehaviour")

	hello         := src.init_member(&foo, "Hello", .String, "Hello World")
	one           := src.init_member(&foo, "One", .Int, "1")

	debug_log     := src.add_function(&foo, "Debug.Log", "UnityEngine", 1, 1, 1) 
	debug_log_one := src.add_function(&foo, "Debug.Log", "UnityEngine", 1, 1, 1) 
	start         := src.add_function(&foo, "Start", "UnityEngine", 0, 0, 1) 
	awake         := src.add_function(&foo, "Awake", "UnityEngine", 0, 0, 1) 

	src.link_function(start, debug_log)
	src.link_variable(hello, debug_log)

	src.application_init(800, 680, "Navi")
	for !src.application_should_close() {
		src.application_update(&foo)
	}

	src.destroy_class(&foo)
	fmt.println("Saved Successfully")
}
