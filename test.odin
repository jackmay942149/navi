package main

import navi "./src"
import os   "core:os"
import test "core:testing"

@(test)
empty_class :: proc(t: ^test.T) {
	empty := navi.init_class("Empty", "MonoBehaviour")
	navi.save_class(&empty)
	util_check_output_file("./Empty.cs", "./tests/Empty.cs", t)
	navi.destroy_class(&empty)
	os.remove("./Empty.cs")
}

util_check_output_file :: proc(outfile, testfile: string, t: ^test.T, allocator := context.temp_allocator) {
	context.allocator = allocator
	outfile_data, _  := os.read_entire_file_from_filename(outfile)
	testfile_data, _ := os.read_entire_file_from_filename(testfile)

	test.expect_value(t, len(outfile_data), len(testfile_data))
	for b, i in outfile_data {
		test.expect_value(t, b, testfile_data[i])
	}
	free_all(context.allocator)
}

