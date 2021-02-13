class zcl_markdown_browser_range definition
  public final.

  public section.
    methods single_object
      importing value       type string
      returning value(self) type ref to zcl_markdown_browser_range.

    methods single_objects
      importing values      type stringtab
      returning value(self) type ref to zcl_markdown_browser_range.

    methods get
      returning value(result) type rsis_t_range.

  private section.
    data range type rsis_t_range.

endclass.



class zcl_markdown_browser_range implementation.

  method single_object.

    append value #(
     sign = 'I'
     option = 'EQ'
     low = value ) to me->range.

    self = me.

  endmethod.

  method single_objects.

    loop at values assigning field-symbol(<value>).
      single_object( <value> ).
    endloop.

    self = me.

  endmethod.

  method get.
    result = me->range.
  endmethod.

endclass.
