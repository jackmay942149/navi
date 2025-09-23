package main

import navi "./src"
import os   "core:os"
import fmt  "core:fmt"
import test "core:testing"

@(test)
debug_vector :: proc(t: ^test.T) {
	class := navi.init_class("DebugVector", "MonoBehaviour")
	m_vec := navi.init_member(&class, "temp", navi.Unity_Vector3f, {})
	f_start := navi.add_function(&class, navi.Unity_Start)
	f_debug := navi.add_function(&class, navi.Unity_DebugLog)

	navi.link_function(f_start, f_debug)
	navi.link_variable(m_vec.fields[2], f_debug)

	navi.save_class(&class)
	navi.destroy_class(&class)
}

@(test)
rigidbody_example :: proc(t: ^test.T) {
	class             := navi.init_class("Vector3CtorExample", "MonoBehaviour")	
	m_vec             := navi.init_member(&class, "m_YDirectionVector", navi.Unity_Vector3f, {})
	m_rb              := navi.init_member(&class, "m_Rigidbody", navi.Unity_Rigidbody, {})
	m_speed           := navi.init_member_new(&class, "m_Speed", .Float, "2", {})
	zero              := navi.add_variable(&class, .Float, "0", {})
	one               := navi.add_variable(&class, .Float, "1", {})
	f_start           := navi.add_function(&class, navi.Unity_Start)
	f_update          := navi.add_function(&class, navi.Unity_Update)
	f_vec3constructor := navi.add_function(&class, navi.Unity_Vec3Constructor)
	f_rbget           := navi.add_function(&class, navi.Unity_GetComponent)
	f_times           := navi.add_function(&class, navi.Times)

	// Add Vec3 Constructor
	navi.link_function(f_start, f_vec3constructor)
	navi.link_variable(zero, f_vec3constructor, 0)
	navi.link_variable(one, f_vec3constructor, 1)
	navi.link_variable(zero, f_vec3constructor, 2)
	navi.link_output(m_vec, f_vec3constructor)

	// Add rb cache
	navi.link_function(f_vec3constructor, f_rbget)
	navi.link_output(m_rb, f_rbget)

	// Move rb
	navi.link_function(f_update, f_times)
	navi.link_variable(m_vec, f_times, 0)
	navi.link_variable(m_speed, f_times, 1)
	navi.link_output(m_rb.fields[0], f_times)

	navi.save_class(&class)
	test.expect(t, util_check_output_file("./Vector3CtorExample.cs", "./tests/Vector3CtorExample.cs"))
	navi.destroy_class(&class)
	if t.error_count == 0 {
		os.remove("./Vector3CtorExample.cs")
	}
	free_all()
}

@(test)
debug_log_example :: proc(t: ^test.T) {
	class := navi.init_class("DebugLogExample", "MonoBehaviour")
	bar := navi.init_member_new(&class, "Bar", .String, "Hello, World!", {})
	awake := navi.add_function(&class, navi.Unity_Awake)
	debug_log := navi.add_function(&class, navi.Unity_DebugLog)
	navi.link_function(awake, debug_log)
	navi.link_variable(bar, debug_log)
	navi.save_class(&class)
	test.expect(t, util_check_output_file("./DebugLogExample.cs", "./tests/DebugLogExample.cs"))
	navi.destroy_class(&class)
	if t.error_count == 0 {
		os.remove("./DebugLogExample.cs")
	}
	free_all()
}

@(test)
empty_class :: proc(t: ^test.T) {
	empty := navi.init_class("Empty", "MonoBehaviour")
	navi.save_class(&empty)
	test.expect(t, util_check_output_file("./Empty.cs", "./tests/Empty.cs"))
	navi.destroy_class(&empty)
	if t.error_count == 0 {
		os.remove("./Empty.cs")
	}
	free_all()
}

@(test)
single_string_member :: proc(t: ^test.T) {
	foo := navi.init_class("SingleStringMember", "MonoBehaviour")
	bar := navi.init_member_new(&foo, "Bar", .String, "Bar", {})
	navi.save_class(&foo)
	test.expect(t, util_check_output_file("./SingleStringMember.cs", "./tests/SingleStringMember.cs"))
	navi.destroy_class(&foo)
	if t.error_count == 0 {
		os.remove("./SingleStringMember.cs")
	}
	free_all()
}

@(test)
single_int_member :: proc(t: ^test.T) {
	foo := navi.init_class("SingleIntMember", "MonoBehaviour")
	bar := navi.init_member_new(&foo, "Bar", .Int, "1", {})
	navi.save_class(&foo)
	test.expect(t, util_check_output_file("./SingleIntMember.cs", "./tests/SingleIntMember.cs"))
	navi.destroy_class(&foo)
	if t.error_count == 0 {
		os.remove("./SingleIntMember.cs")
	}
	free_all()
}

@(test)
single_float_member :: proc(t: ^test.T) {
	foo := navi.init_class("SingleFloatMember", "MonoBehaviour")
	bar := navi.init_member_new(&foo, "Bar", .Float, "1", {})
	navi.save_class(&foo)
	test.expect(t, util_check_output_file("./SingleFloatMember.cs", "./tests/SingleFloatMember.cs"))
	navi.destroy_class(&foo)
	if t.error_count == 0 {
		os.remove("./SingleFloatMember.cs")
	}
	free_all()
}

@(test)
single_float_member_decimal :: proc(t: ^test.T) {
	foo := navi.init_class("SingleFloatMember", "MonoBehaviour")
	bar := navi.init_member_new(&foo, "Bar", .Float, "1.0", {})
	navi.save_class(&foo)
	test.expect(t, util_check_output_file("./SingleFloatMember.cs", "./tests/SingleFloatMember.cs"))
	navi.destroy_class(&foo)
	if t.error_count == 0 {
		os.remove("./SingleFloatMember.cs")
	}
	free_all()
}

@(test)
single_vec3_member :: proc(t: ^test.T) {
	foo := navi.init_class("SingleVec3Member", "MonoBehaviour")
	bar := navi.init_member_new(&foo, "Bar", .Vector3, "", {})
	navi.save_class(&foo)
	test.expect(t, util_check_output_file("./SingleVec3Member.cs", "./tests/SingleVec3Member.cs"))
	navi.destroy_class(&foo)
	if t.error_count == 0 {
		os.remove("./SingleVec3Member.cs")
	}
	free_all()
}

util_check_output_file :: proc(outfile, testfile: string, allocator := context.temp_allocator) -> (same: bool){
	context.allocator = allocator
	outfile_data, _  := os.read_entire_file_from_filename(outfile)
	testfile_data, _ := os.read_entire_file_from_filename(testfile)

	if len(outfile_data) != len(testfile_data) {
		return false
	}
	for b, i in outfile_data {
		if b != outfile_data[i] {
			return false
		}
	}
	return true
}

