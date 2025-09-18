# Draw Call Planning

# Elements
- Member (Node)
- Function (Node)
- Inspector
# Components
- Exec (Pin)
- Input (Pin)
- Output (Pin)
- Textbox
- Button
- Form
# Shapes
- Circle
- Rectangle
- Rounded Rectangle
- Line
- Bezier
- Text

Member
 - BG: RoundedRectangle
 - Name: Textbox (Text)
 - Type: Textbox (Text)
 - Output: Output (Circle)

Function
 - Name: Textbox (Text)
 - Execution In: Exec (Circle)
 - Execution Out: Exec (Circle)
 - Inputs: Input (Circle)
 - Input Types: Textbox (Text)

Inspector
 - Titles: Textbox (Text)
 - Additions: Buttons (Rectangle, Text)
 - Changes: Form (Rectangle, Text)

Draw Order All
1) Background
2) Members
3) Functions
4) Lines
5) Inspector

