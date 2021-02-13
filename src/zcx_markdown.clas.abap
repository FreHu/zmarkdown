class zcx_markdown definition
  public final
  inheriting from cx_no_check.

  public section.
    methods constructor
      importing reason type string.

    data reason type string read-only.
  protected section.
  private section.
endclass.



class zcx_markdown implementation.
  method constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( ).
    me->reason = reason.
  endmethod.

endclass.
