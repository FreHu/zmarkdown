CLASS zcl_markdown_style DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.

    "! Bold (**val**)
    METHODS bold
      IMPORTING val           TYPE string
      RETURNING VALUE(result) TYPE string.

    "! Italic (**val**)
    METHODS italic
      IMPORTING val           TYPE string
      RETURNING VALUE(result) TYPE string.

    "! Italic bold (***val***) <br>
    "! You might think this is the same thing as bold_italic, but <br>
    "! - in italic_bold, the first * represents italic and the last ** represent bold <br>
    "! - in bold_italic, the first two ** represent bold and the last * represents italic <br>
    "! This fact should have no practical consequences whatsoever.
    METHODS italic_bold
      IMPORTING val           TYPE string
      RETURNING VALUE(result) TYPE string.

    "! Bold italic (***val***) <br>
    "! You might think this is the same thing as italic_bold, but <br>
    "! - in italic_bold, the first * represents italic and the last ** represent bold <br>
    "! - in bold_italic, the first two ** represent bold and the last * represents italic <br>
    "! This fact should have no practical consequences whatsoever.
    METHODS bold_italic
      IMPORTING val           TYPE string
      RETURNING VALUE(result) TYPE string.

    "! Inline code (`val`)
    METHODS inline_code
      IMPORTING val           TYPE string
      RETURNING VALUE(result) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_markdown_style IMPLEMENTATION.

  METHOD bold.
    result = |**{ val }**|.
  ENDMETHOD.

  METHOD italic.
    result = |*{  val }*|.
  ENDMETHOD.

  METHOD italic_bold.
    result = |***{  val }***|.
  ENDMETHOD.

  METHOD bold_italic.
    result = |***{  val }***|.
  ENDMETHOD.

  METHOD inline_code.
    result = |`{ val }`|.
  ENDMETHOD.

ENDCLASS.
