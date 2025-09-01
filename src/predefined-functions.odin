package src

Predefined_Function :: struct {
	name:           string,
	directive:      string,
	input_count:    int,
	exec_in_count:  int,
	exec_out_count: int,
}

Unity_DebugLog :: Predefined_Function {
	name = "Debug.Log",
	directive = "UnityEngine",
	input_count = 1,
	exec_in_count = 1,
	exec_out_count = 1,
}

Unity_Start :: Predefined_Function {
	name = "Start",
	directive = "UnityEngine",
	input_count = 0,
	exec_in_count = 0,
	exec_out_count = 1,
}

Unity_Awake :: Predefined_Function {
	name = "Awake",
	directive = "UnityEngine",
	input_count = 0,
	exec_in_count = 0,
	exec_out_count = 1,
}

Unity_Update :: Predefined_Function {
	name = "Update",
	directive = "UnityEngine",
	input_count = 0,
	exec_in_count = 0,
	exec_out_count = 1,
}
