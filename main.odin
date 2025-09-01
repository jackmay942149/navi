package main

import navi "./src"
import fmt  "core:fmt"

// main :: proc() {
// 	foo           := navi.init_class("Foo", "MonoBehaviour")

// 	debug_log     := navi.add_function(&foo, "Debug.Log", "UnityEngine", 1, 1, 1) 
// 	debug_log_one := navi.add_function(&foo, "Debug.Log", "UnityEngine", 1, 1, 1) 
// 	start         := navi.add_function(&foo, "Start", "UnityEngine", 0, 0, 1) 
// 	awake         := navi.add_function(&foo, "Awake", "UnityEngine", 0, 0, 1) 

// 	navi.link_function(start, debug_log)

// 	navi.application_init(800, 680, "Navi")
// 	for !navi.application_should_close() {
// 		navi.application_update(&foo)
// 	}

// 	navi.save_class(&foo)
// 	navi.destroy_class(&foo)
// 	fmt.println("Saved Successfully")
// }

main :: proc() {
	class := navi.init_class("DebugLogExample", "MonoBehaviour")
	bar := navi.init_member(&class, "Bar", .String, "Hello, World!", {})
	awake := navi.add_function(&class, "Awake", "UnityEngine", 0, 0, 1)
	debug_log := navi.add_function(&class, "Debug.Log", "UnityEngine", 1, 1, 1)
	navi.link_function(awake, debug_log)
	navi.link_variable(bar, debug_log)
	navi.save_class(&class)
	navi.destroy_class(&class)
	check_output_file("./DebugLogExample.cs","./tests/DebugLogExample.cs")
	free_all()
}
import "core:os"
check_output_file :: proc(outfile, testfile: string, allocator := context.temp_allocator) -> (same: bool){
	context.allocator = allocator
	outfile_data, _  := os.read_entire_file_from_filename(outfile)
	testfile_data, _ := os.read_entire_file_from_filename(testfile)

	if len(outfile_data) != len(testfile_data) {
		fmt.println(len(outfile_data), len(testfile_data))
		assert(false)
		return false
	}
	for b, i in outfile_data {
		if b != outfile_data[i] {
			assert(false)
			return false
		}
	}
	return true
}
