package main

import navi "./src"
import fmt  "core:fmt"

main :: proc() {
	foo           := navi.init_class("Foo", "MonoBehaviour")

	debug_log     := navi.add_function(&foo, "Debug.Log", "UnityEngine", 1, 1, 1) 
	debug_log_one := navi.add_function(&foo, "Debug.Log", "UnityEngine", 1, 1, 1) 
	start         := navi.add_function(&foo, "Start", "UnityEngine", 0, 0, 1) 
	awake         := navi.add_function(&foo, "Awake", "UnityEngine", 0, 0, 1) 

	navi.link_function(start, debug_log)

	navi.application_init(800, 680, "Navi")
	for !navi.application_should_close() {
		navi.application_update(&foo)
	}

	navi.save_class(&foo)
	navi.destroy_class(&foo)
	fmt.println("Saved Successfully")
}
