class zcl_oo_plugin_object_info_md definition
  public final create public.

  public section.

    interfaces: zif_oo_plugin_object_info.

    methods:
      display_string
        importing html_string         type string
        returning value(assigned_url) type w3url.

  protected section.
  private section.

    "! Base sapgui control
    data gui_control type ref to cl_gui_html_viewer.
    methods:
      string_to_bintab importing html_string   type string
                       returning value(result) type lvc_t_mime.

endclass.



class zcl_oo_plugin_object_info_md implementation.

  method display_string.

    data(binary_data) = string_to_bintab( html_string ).
    gui_control->load_data(
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

    gui_control->show_url(
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

  method zif_oo_plugin_object_info~display.
    me->gui_control = gui_control.

    if object_type = 'CLAS'.
      try.
          data(md) = new zcl_markdown_docu_clas(
            class_name = conv #( object_name )
            document = new zcl_markdown( ) ).
          display_string(
            zcl_markdown_html=>html(
              zcl_markdown_html=>body( |<pre>{ md->doc->content }</pre>| ) ) ).
        catch zcx_markdown into data(cx).
          display_string(
        |<html><body>| &&
        |<h1>Problem</h1>| &&
        |Exception occurred when generating, { cx->reason }| &&
        |</body></html>| ).
      endtry.
    else.
      display_string(
      |<html><body>| &&
      |<h1>Not Supported</h1>| &&
      |Documentation not yet supported for object type { object_type }| &&
      |</body></html>| ).
    endif.


  endmethod.

  method zif_oo_plugin~get_info.
    result-id = 'OBJECT_INFO_MARKDOWN'.
    result-category = zif_oo_plugin_object_info=>category.
    result-description = 'Render Markdown'.
    result-class_name = 'ZCL_OO_PLUGIN_OBJECT_INFO_MD'.
  endmethod.

  method zif_oo_plugin~is_enabled.
    result = abap_true.
  endmethod.

endclass.
