CLASS zcl_oo_plugin_object_info_md DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES: zif_oo_plugin_object_info.

    METHODS constructor.

    METHODS:
      display_string
        IMPORTING html_string         TYPE string
        RETURNING VALUE(assigned_url) TYPE w3url.

  PROTECTED SECTION.
  PRIVATE SECTION.

    "! Base sapgui control
    DATA gui_control TYPE REF TO cl_gui_html_viewer.
    METHODS:
      string_to_bintab IMPORTING html_string   TYPE string
                       RETURNING VALUE(result) TYPE lvc_t_mime.

ENDCLASS.



CLASS zcl_oo_plugin_object_info_md IMPLEMENTATION.

  METHOD constructor.
  ENDMETHOD.

  METHOD display_string.

    DATA(binary_data) = string_to_bintab( html_string ).
    gui_control->load_data(
      EXPORTING
        type         = `text`
        subtype      = `html`
      IMPORTING
        assigned_url = assigned_url
      CHANGING
        data_table   = binary_data
      EXCEPTIONS
        OTHERS       = 1 ).

    CHECK sy-subrc = 0.

    gui_control->show_url(
      EXPORTING url = assigned_url
      EXCEPTIONS OTHERS = 1 ).

    CHECK sy-subrc = 0.
  ENDMETHOD.

  METHOD string_to_bintab.

    TRY.
        DATA(html_xstring) = cl_bcs_convert=>string_to_xstring( iv_string = html_string ).
        CHECK html_xstring IS NOT INITIAL.
      CATCH cx_bcs.
        RETURN.
    ENDTRY.

    DATA: bin_size TYPE i.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = html_xstring
      IMPORTING
        output_length = bin_size
      TABLES
        binary_tab    = result.

    CHECK sy-subrc = 0.
  ENDMETHOD.

  METHOD zif_oo_plugin_object_info~display.
    me->gui_control = gui_control.

    IF object_type = 'CLAS'.
      TRY.
          DATA(md) = NEW zcl_markdown_docu_clas(
            class_name = CONV #( object_name )
            document = NEW zcl_markdown( ) ).
          display_string(
            zcl_markdown_html=>html(
              zcl_markdown_html=>body( |<pre>{ md->doc->content }</pre>| ) ) ).
        CATCH zcx_markdown INTO DATA(cx).
          display_string(
        |<html><body>| &&
        |<h1>Problem</h1>| &&
        |Exception occurred when generating, { cx->reason }| &&
        |</body></html>| ).
      ENDTRY.
    ELSE.
      display_string(
      |<html><body>| &&
      |<h1>Not Supported</h1>| &&
      |Documentation not yet supported for object type { object_type }| &&
      |</body></html>| ).
    ENDIF.


  ENDMETHOD.

  METHOD zif_oo_plugin~get_info.
    result-id = 'OBJECT_INFO_MARKDOWN'.
    result-category = zif_oo_plugin_object_info=>category.
    result-description = 'Render Markdown'.
    result-class_name = 'ZCL_OO_PLUGIN_OBJECT_INFO_MD'.
  ENDMETHOD.

  METHOD zif_oo_plugin~is_enabled.
    result = abap_true.
  ENDMETHOD.

ENDCLASS.
