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
  CSharp_Bool,
  Custom_Mover,
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
  fields = {Unity_Linear_Velocity, Unity_Angular_Damping, Unity_Angular_Velocity, Unity_Automatic_Center_Of_Mass, Unity_Automatic_Inertia_Tensor, Unity_Center_Of_Mass, Unity_Detect_Collisions, Unity_Freeze_Rotation, Unity_Inertia_Tensor, Unity_Is_Kinematic, Unity_Linear_Damping, Unity_Mass, Unity_Max_Angular_Velocity, Unity_Max_Depenetraction_Velocity, Unity_Max_Linear_Velocity, Unity_Position, Unity_Sleep_Threshold, Unity_Solver_Iterations, Unity_Solver_Velocity_Iterations, Unity_Use_Gravity, }
}

Unity_Angular_Damping :: Predefined_Type {
  type = .Float,
  name = "angularDamping",
}

Unity_Angular_Velocity :: Predefined_Type {
  type = .Vector3,
  name = "angularVelocity",
  fields = {Unity_Float_X, Unity_Float_Y, Unity_Float_Z, }
}

Unity_Automatic_Center_Of_Mass :: Predefined_Type {
  type = .Bool,
  name = "automaticCenterOfMass",
}

Unity_Automatic_Inertia_Tensor :: Predefined_Type {
  type = .Bool,
  name = "automaticInertiaTensor",
}

Unity_Center_Of_Mass :: Predefined_Type {
  type = .Vector3,
  name = "centerOfMass",
  fields = {Unity_Float_X, Unity_Float_Y, Unity_Float_Z, }
}

Unity_Detect_Collisions :: Predefined_Type {
  type = .Bool,
  name = "detectCollisions",
}

Unity_Freeze_Rotation :: Predefined_Type {
  type = .Bool,
  name = "freezeRotation",
}

Unity_Inertia_Tensor :: Predefined_Type {
  type = .Vector3,
  name = "inertiaTensor",
  fields = {Unity_Float_X, Unity_Float_Y, Unity_Float_Z, }
}

Unity_Is_Kinematic :: Predefined_Type {
  type = .Bool,
  name = "isKinematic",
}

Unity_Linear_Damping :: Predefined_Type {
  type = .Float,
  name = "linearDamping",
}

Unity_Mass :: Predefined_Type {
  type = .Float,
  name = "mass",
}

Unity_Max_Angular_Velocity :: Predefined_Type {
  type = .Float,
  name = "maxAngularVelocity",
}

Unity_Max_Depenetraction_Velocity :: Predefined_Type {
  type = .Float,
  name = "maxDepenetrationVelocity",
}

Unity_Max_Linear_Velocity :: Predefined_Type {
  type = .Float,
  name = "maxLinearVelocity",
}

Unity_Position :: Predefined_Type {
  type = .Vector3,
  name = "position",
  fields = {Unity_Float_X, Unity_Float_Y, Unity_Float_Z, }
}

Unity_Sleep_Threshold :: Predefined_Type {
  type = .Float,
  name = "sleepThreshold",
}

Unity_Solver_Iterations :: Predefined_Type {
  type = .Int,
  name = "solverIterations",
}

Unity_Solver_Velocity_Iterations :: Predefined_Type {
  type = .Int,
  name = "solverVelocityIterations",
}

Unity_Use_Gravity :: Predefined_Type {
  type = .Bool,
  name = "useGravity",
}

CSharp_Bool :: Predefined_Type {
  type = .Bool,
}

Mover_Speed :: Predefined_Type {
  type = .Float,
  name = "speed",
}

Custom_Mover :: Predefined_Type {
  type = .Mover,
  fields = {Mover_Speed, }
}

