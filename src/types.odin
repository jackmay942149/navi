package src

Variable_Type :: enum {
  String,
  Int,
  Float,
  Vector3,
  Rigidbody,
  Bool,
}

@(rodata)
Variable_Type_Id := [?]cstring {
  " S",
  " I",
  " F",
  "V3",
  "Rb",
  " B",
}

@(rodata)
Variable_Type_As_String := [?]string {
  "string",
  "int",
  "float",
  "Vector3",
  "Rigidbody",
  "bool",
}

@(rodata)
Variable_Type_As_CString := [?]cstring {
  "string",
  "int",
  "float",
  "Vector3",
  "Rigidbody",
  "bool",
}

