class zcl_markdown_browser_gui definition
  public final create public.

  public section.
    methods:
      constructor
        importing
          screen_number  type sy-dynnr
          value(program) type sy-repid
          objects        type zif_markdown_browser_types=>t_objects,
      show_results_for
        importing
          object type zif_markdown_browser_types=>t_grid_line.

    data:
      splitter          type ref to cl_gui_splitter_container read-only,
      docking_container type ref to cl_gui_docking_container read-only,
      left_container    type ref to cl_gui_container read-only,
      right_container   type ref to cl_gui_container read-only,
      alv_grid_left     type ref to zcl_markdown_browser_gui_alv read-only,
      html_viewer_right type ref to zcl_markdown_browser_gui_html read-only,

      objects           type zif_markdown_browser_types=>t_objects read-only,
      results           type zif_markdown_browser_types=>t_object_result_map read-only.


  protected section.
  private section.
    methods setup_left_grid.

endclass.



class zcl_markdown_browser_gui implementation.


  method constructor.

    me->objects = objects.

    docking_container = new cl_gui_docking_container(
      repid = program
      dynnr = screen_number
      extension = 5000 ).

    splitter = new cl_gui_splitter_container(
      align = 15
      parent = docking_container
      rows = 1
      columns = 2 ).

    right_container = splitter->get_container( row = 1 column = 2 ).
    left_container  = splitter->get_container( row = 1 column = 1 ).

    me->alv_grid_left = new #(
      gui  = me
      grid = new #( i_parent = me->left_container ) ).

    me->html_viewer_right = new #(
      new #( parent = me->right_container ) ).

    setup_left_grid( ).

  endmethod.

  method setup_left_grid.

    data(field_catalog) = value lvc_t_fcat(
      ( fieldname = 'object_type' scrtext_m = 'Object type' outputlen = 6 )
      ( fieldname = 'object_name' scrtext_m = 'Object name' outputlen = 30 )
      ( fieldname = 'hotspot_show' scrtext_m = 'Documentation' hotspot = abap_true )
    ).

    me->alv_grid_left->set_field_catalog( field_catalog ).
    me->alv_grid_left->set_layout( value #( zebra = abap_true ) ).

    data(grid_lines) = value zif_markdown_browser_types=>t_grid_lines(
      for <o> in objects
        ( object_type = <o>-object
          object_name = <o>-obj_name
          hotspot_show = icon_show_events
        ) ).

    me->alv_grid_left->set_lines( grid_lines ).
    me->alv_grid_left->display( ).

  endmethod.

  method show_results_for.
    return.
    " todo show markdown html
  endmethod.

endclass.