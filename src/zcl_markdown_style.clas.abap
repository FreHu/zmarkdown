class zcl_markdown_style definition
  public final.

  public section.

    "! Bold (**val**)
    methods bold
      importing val           type string
      returning value(result) type string.

    "! Italic (**val**)
    methods italic
      importing val           type string
      returning value(result) type string.

    "! Italic bold (***val***) <br>
    "! You might think this is the same thing as bold_italic, but <br>
    "! - in italic_bold, the first * represents italic and the last ** represent bold <br>
    "! - in bold_italic, the first two ** represent bold and the last * represents italic <br>
    "! This fact should have no practical consequences whatsoever.
    methods italic_bold
      importing val           type string
      returning value(result) type string.

    "! Bold italic (***val***) <br>
    "! You might think this is the same thing as italic_bold, but <br>
    "! - in italic_bold, the first * represents italic and the last ** represent bold <br>
    "! - in bold_italic, the first two ** represent bold and the last * represents italic <br>
    "! This fact should have no practical consequences whatsoever.
    methods bold_italic
      importing val           type string
      returning value(result) type string.

    "! Inline code (`val`)
    methods inline_code
      importing val           type string
                omit_empty    type abap_bool default abap_true
      returning value(result) type string.

  protected section.
  private section.
endclass.



class zcl_markdown_style implementation.

  method bold.
    result = |**{ val }**|.
  endmethod.

  method italic.
    result = |*{  val }*|.
  endmethod.

  method italic_bold.
    result = |***{  val }***|.
  endmethod.

  method bold_italic.
    result = |***{  val }***|.
  endmethod.

  method inline_code.
    if omit_empty = abap_true.
      check val is not initial.
    endif.
    result = |`{ val }`|.
  endmethod.

endclass.
