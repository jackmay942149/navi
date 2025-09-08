package main

import navi "./src"
import fmt  "core:fmt"

main :: proc() {
	foo := navi.init_class("Foo", "MonoBehaviour")

	app := navi.application_init(800, 680, "Navi")
	for !navi.application_should_close() {
		navi.application_update(&foo, &app)
	}

	navi.save_class(&foo)
	navi.destroy_class(&foo)
	fmt.println("Saved Successfully")
}
