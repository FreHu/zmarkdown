class zcl_markdown_browser_gui_html definition
  public final create public.

  public section.

    "! Base sapgui control
    data base type ref to cl_gui_html_viewer read-only.

    methods constructor
      importing
        base type ref to cl_gui_html_viewer.

    methods:
      display_string
        importing html_string         type string
        returning value(assigned_url) type w3url.

  protected section.
  private section.
    methods:
      string_to_bintab importing html_string   type string
                       returning value(result) type lvc_t_mime.

endclass.



class zcl_markdown_browser_gui_html implementation.

  method constructor.
    me->base = base.
  endmethod.

  method display_string.

    data(binary_data) = string_to_bintab( html_string ).
    base->load_data(
      exporting
        type         = `text`
        subtype      = `html`
      importing
        assigned_url = assigned_url
      changing
        data_table   = binary_data
      exceptions
        others       = 1 ).

    check sy-subrc = 0.

    base->show_url(
      exporting url = assigned_url
      exceptions others = 1 ).

    check sy-subrc = 0.
  endmethod.

  method string_to_bintab.

    try.
        data(html_xstring) = cl_bcs_convert=>string_to_xstring( iv_string = html_string ).
        check html_xstring is not initial.
      catch cx_bcs.
        return.
    endtry.

    data: bin_size type i.

    call function 'SCMS_XSTRING_TO_BINARY'
      exporting
        buffer        = html_xstring
      importing
        output_length = bin_size
      tables
        binary_tab    = result.

    check sy-subrc = 0.
  endmethod.

endclass.
