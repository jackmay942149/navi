package src

Predefined_Function :: struct {
	name, directive: string,
	type:            FunctionType,
	has_output:      bool,
	input_count, exec_in_count, exec_out_count: int,
}

@(rodata)
Available_Functions := []Predefined_Function {
  Times,
  Add,
  Divide,
  Subtract,
  Unity_DebugLog,
  Unity_Start,
  Unity_Awake,
  Unity_Update,
  Unity_Vec3Constructor,
  Unity_GetComponent,
  Unity_AddComponent,
}

Times :: Predefined_Function {
  name = "*",
  directive = "",
  type = .Binary,
  has_output = true,
  input_count = 2,
  exec_in_count = 1,
  exec_out_count = 1,
}

Add :: Predefined_Function {
  name = "+",
  directive = "",
  type = .Binary,
  has_output = true,
  input_count = 2,
  exec_in_count = 1,
  exec_out_count = 1,
}

Divide :: Predefined_Function {
  name = "/",
  directive = "",
  type = .Binary,
  has_output = true,
  input_count = 2,
  exec_in_count = 1,
  exec_out_count = 1,
}

Subtract :: Predefined_Function {
  name = "-",
  directive = "",
  type = .Binary,
  has_output = true,
  input_count = 2,
  exec_in_count = 1,
  exec_out_count = 1,
}

Unity_DebugLog :: Predefined_Function {
  name = "Debug.Log",
  directive = "UnityEngine",
  type = .Standard,
  has_output = false,
  input_count = 1,
  exec_in_count = 1,
  exec_out_count = 1,
}

Unity_Start :: Predefined_Function {
  name = "Start",
  directive = "UnityEngine",
  type = .Standard,
  has_output = false,
  input_count = 0,
  exec_in_count = 0,
  exec_out_count = 1,
}

Unity_Awake :: Predefined_Function {
  name = "Awake",
  directive = "UnityEngine",
  type = .Standard,
  has_output = false,
  input_count = 0,
  exec_in_count = 0,
  exec_out_count = 1,
}

Unity_Update :: Predefined_Function {
  name = "Update",
  directive = "UnityEngine",
  type = .Standard,
  has_output = false,
  input_count = 0,
  exec_in_count = 0,
  exec_out_count = 1,
}

Unity_Vec3Constructor :: Predefined_Function {
  name = "new Vector3",
  directive = "UnityEngine",
  type = .Standard,
  has_output = true,
  input_count = 3,
  exec_in_count = 1,
  exec_out_count = 1,
}

Unity_GetComponent :: Predefined_Function {
  name = "GetComponent",
  directive = "UnityEngine",
  type = .Template,
  has_output = true,
  input_count = 0,
  exec_in_count = 1,
  exec_out_count = 1,
}

Unity_AddComponent :: Predefined_Function {
  name = "AddComponent",
  directive = "UnityEngine",
  type = .Template,
  has_output = true,
  input_count = 0,
  exec_in_count = 1,
  exec_out_count = 1,
}

