package main

import "./src"
import "core:fmt"

main :: proc() {
	foo := src.init_class("Foo", "MonoBehaviour")
	hello := src.init_member(&foo, "Hello", .String, "Hello World")
	one := src.init_member(&foo, "One", .Int, "1")
	src.save_class(&foo)
	fmt.println("Saved Successfully")
}
