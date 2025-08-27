# Navi - Struct Planning and Examples

# Struct - Variable
- Name (String)
- Type (String)
- Fields ([]Variable)
- Value (String)

# Struct - Function
- Name (String)
- Output (Variable)
- Inputs ([]^Variable)
- Using (String)
- Execution Ins Count (Int)
- Execution Ins ([]^Function Call)
- Excecution Outs Count (Int)
- Execution Outs ([]^Function Call)

# Struct - Graph
- Class Name (String)
- Inheritance Name (String) // Could be []String in future
- Functions ([]Function)
- Variables ([]Variable)

# Example Graph - Hello World
## Function 
- Name: "Start"
- Output: void
- Inputs: {void}
- Using: "UnityEngine"
- Execution Ins Count: 0
- Execution Ins: Nil
- Execution Outs Count: 1
- Execution Outs: {&Debug.Log}

## Variable
- Name: "Hello"
- Type: "string"
- Fields: nil
- Value: "Hello World"

## Function
- Name: "Debug.Log"
- Output: void
- Inputs: {&Hello}
- Using: "UnityEngine"
- Execution Ins Count: 1
- Execution Ins: &Start
- Execution Outs Count: 1
- Execution Outs: {nil}

## Graph
- Functions: {&Start, &Debug.Log}
- Variables: {&Hello}
