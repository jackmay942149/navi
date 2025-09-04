package main

import navi "./src"
import fmt  "core:fmt"

main :: proc() {
	foo           := navi.init_class("Foo", "MonoBehaviour")
	debug_log     := navi.add_function(&foo, navi.Unity_DebugLog) 
	debug_log_one := navi.add_function(&foo, navi.Unity_DebugLog) 
	start         := navi.add_function(&foo, navi.Unity_Start) 
	awake         := navi.add_function(&foo, navi.Unity_Awake) 

	navi.link_function(start, debug_log)

	navi.application_init(800, 680, "Navi")
	for !navi.application_should_close() {
		navi.application_update(&foo)
	}

	navi.save_class(&foo)
	navi.destroy_class(&foo)
	fmt.println("Saved Successfully")
}
