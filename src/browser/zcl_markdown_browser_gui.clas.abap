CLASS zcl_markdown_browser_gui DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS
      constructor
        IMPORTING
          screen_number  TYPE sy-dynnr
          VALUE(program) TYPE sy-repid
          objects        TYPE zif_markdown_browser_types=>t_objects
          mode_id           TYPE zif_oo_plugin=>t_plugin_info-id.

    METHODS
      show_results_for
        IMPORTING
          object TYPE zif_markdown_browser_types=>t_grid_line.

    DATA:
      splitter          TYPE REF TO cl_gui_splitter_container READ-ONLY,
      docking_container TYPE REF TO cl_gui_docking_container READ-ONLY,
      left_container    TYPE REF TO cl_gui_container READ-ONLY,
      right_container   TYPE REF TO cl_gui_container READ-ONLY,
      alv_grid_left     TYPE REF TO zcl_markdown_browser_gui_alv READ-ONLY,
      html_viewer_right TYPE REF TO cl_gui_html_viewer READ-ONLY,

      mode              TYPE REF TO zif_oo_plugin_object_info READ-ONLY,
      objects           TYPE zif_markdown_browser_types=>t_objects READ-ONLY,
      results           TYPE zif_markdown_browser_types=>t_object_result_map READ-ONLY.


  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS setup_left_grid.


ENDCLASS.



CLASS zcl_markdown_browser_gui IMPLEMENTATION.


  METHOD constructor.

    me->objects = objects.

    docking_container = NEW cl_gui_docking_container(
      repid = program
      dynnr = screen_number
      extension = 5000 ).

    splitter = NEW cl_gui_splitter_container(
      align = 15
      parent = docking_container
      rows = 1
      columns = 2 ).

    right_container = splitter->get_container( row = 1 column = 2 ).
    left_container  = splitter->get_container( row = 1 column = 1 ).

    me->alv_grid_left = NEW #(
      gui  = me
      grid = NEW #( i_parent = me->left_container ) ).

    me->html_viewer_right = NEW #( parent = right_container ).

    setup_left_grid( ).

    me->mode = CAST #( zcl_oo_plugin_provider=>get_by_id(
      category = zif_oo_plugin_object_info=>category
      id = mode_id )-instance ).

  ENDMETHOD.

  METHOD setup_left_grid.

    DATA(field_catalog) = VALUE lvc_t_fcat(
      ( fieldname = 'object_type' scrtext_m = 'Object type' outputlen = 6 )
      ( fieldname = 'object_name' scrtext_m = 'Object name' outputlen = 30 )
      ( fieldname = 'hotspot_show' scrtext_m = 'Documentation' hotspot = abap_true )
    ).

    me->alv_grid_left->set_field_catalog( field_catalog ).
    me->alv_grid_left->set_layout( VALUE #( zebra = abap_true ) ).

    DATA(grid_lines) = VALUE zif_markdown_browser_types=>t_grid_lines(
      FOR <o> IN objects
        ( object_type = <o>-object
          object_name = <o>-obj_name
          hotspot_show = icon_show_events
        ) ).

    me->alv_grid_left->set_lines( grid_lines ).
    me->alv_grid_left->display( ).

  ENDMETHOD.

  METHOD show_results_for.
    mode->display(
      object_type = object-object_type
      object_name = object-object_name
      gui_control = me->html_viewer_right ).
  ENDMETHOD.


ENDCLASS.
