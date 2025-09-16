package src

@(rodata)
Available_Types := []Predefined_Type {
	CSharp_String,
	CSharp_Int,
	CSharp_Float,
	Unity_Vector3f,
	Unity_Rigidbody,
}

Predefined_Type :: struct {
	name:   string,
	type:   Variable_Type,
	fields: []Predefined_Type,
}

CSharp_String :: Predefined_Type {
	type = .String
}

CSharp_Float :: Predefined_Type {
	type = .Float,
}

CSharp_Int :: Predefined_Type {
	type = .Int,
}

Unity_FloatX :: Predefined_Type {
	name = "x",
	type = .Float,
}

Unity_FloatY :: Predefined_Type {
	name = "y",
	type = .Float,
}

Unity_FloatZ :: Predefined_Type {
	name = "z",
	type = .Float,
}

Unity_Vector3f :: Predefined_Type {
	type = .Vector3,
	fields = {Unity_FloatX, Unity_FloatY, Unity_FloatZ}
}

Unity_Rigidbody :: Predefined_Type {
	type = .Rigidbody,
	fields = {
		Predefined_Type{
			name = "linearVelocity",
			type = .Vector3,
			fields = {Unity_FloatX, Unity_FloatY, Unity_FloatZ}
		}
	}
}
