package src

Predefined_Type :: struct {
	name:   string,
	type:   Variable_Type,
	fields: []Predefined_Type,
}

@(rodata)
Available_Types := []Predefined_Type {
  CSharp_String,
  CSharp_Int,
  CSharp_Float,
  Unity_Vector3f,
  Unity_Rigidbody,
}

CSharp_String :: Predefined_Type {
  type = .String,
}

CSharp_Int :: Predefined_Type {
  type = .Int,
}

CSharp_Float :: Predefined_Type {
  type = .Float,
}

Unity_Float_X :: Predefined_Type {
  type = .Float,
  name = "x",
}

Unity_Float_Y :: Predefined_Type {
  type = .Float,
  name = "y",
}

Unity_Float_Z :: Predefined_Type {
  type = .Float,
  name = "z",
}

Unity_Vector3f :: Predefined_Type {
  type = .Vector3,
  fields = {Unity_Float_X, Unity_Float_Y, Unity_Float_Z, }
}

Unity_Linear_Velocity :: Predefined_Type {
  type = .Vector3,
  name = "linearVelocity",
  fields = {Unity_Float_X, Unity_Float_Y, Unity_Float_Z, }
}

Unity_Rigidbody :: Predefined_Type {
  type = .Rigidbody,
  fields = {Unity_Linear_Velocity, }
}

