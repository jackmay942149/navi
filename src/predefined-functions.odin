package src

@(rodata)
Available_Functions := []Predefined_Function {
	Times,
	Unity_DebugLog,
	Unity_Start,
	Unity_Awake,
	Unity_Update,
	Unity_Vec3Constructor,
	Unity_GetComponent,
}

Predefined_Function :: struct {
	name, directive:                            string,
	type:                                       FunctionType,
	input_count, exec_in_count, exec_out_count: int,
}

Times :: Predefined_Function {
	name           = "*",
	type           = .Binary,
	input_count    = 2,
	exec_in_count  = 1,
	exec_out_count = 1,
}

Unity_DebugLog :: Predefined_Function {
	name           = "Debug.Log",
	directive      = "UnityEngine",
	input_count    = 1,
	exec_in_count  = 1,
	exec_out_count = 1,
}

Unity_Start :: Predefined_Function {
	name           = "Start",
	directive      = "UnityEngine",
	input_count    = 0,
	exec_in_count  = 0,
	exec_out_count = 1,
}

Unity_Awake :: Predefined_Function {
	name           = "Awake",
	directive      = "UnityEngine",
	input_count    = 0,
	exec_in_count  = 0,
	exec_out_count = 1,
}

Unity_Update :: Predefined_Function {
	name           = "Update",
	directive      = "UnityEngine",
	input_count    = 0,
	exec_in_count  = 0,
	exec_out_count = 1,
}

Unity_Vec3Constructor :: Predefined_Function {
	name           = "new Vector3",
	directive      = "UnityEngine",
	input_count    = 3,
	exec_in_count  = 1,
	exec_out_count = 1,
}

Unity_GetComponent :: Predefined_Function {
	name           = "GetComponent",
	directive      = "UnityEngine",
	type           = .Template,
	input_count    = 1,
	exec_in_count  = 1,
	exec_out_count = 1,
}
