class zcl_markdown_browser_gui_alv definition
  public final create public.

  public section.
    methods constructor
      importing
        gui  type ref to zcl_markdown_browser_gui
        grid type ref to cl_gui_alv_grid.

    methods set_field_catalog
      importing catalog type lvc_t_fcat.

    methods set_layout
      importing layout type lvc_s_layo.

    methods set_lines
      importing lines type zif_markdown_docu_browser_types=>t_grid_lines.

    methods display.

    methods handle_hotspot_click
      for event hotspot_click of cl_gui_alv_grid
      importing e_row_id e_column_id.

  private section.
    methods get_clicked_row
      importing row_index     type lvc_index
      returning value(result) type zif_markdown_docu_browser_types=>t_grid_line.

    data gui type ref to zcl_markdown_browser_gui.
    data grid type ref to cl_gui_alv_grid.
    data lines type zif_markdown_docu_browser_types=>t_grid_lines.
    data catalog type lvc_t_fcat.
    data layout type lvc_s_layo.
endclass.



class zcl_markdown_browser_gui_alv implementation.

  method constructor.
    me->gui = gui.
    me->grid = grid.
  endmethod.

  method display.
    me->grid->set_table_for_first_display(
      exporting
        i_buffer_active               = abap_false
        is_layout                     = layout
      changing
        it_outtab                     = me->lines
        it_fieldcatalog               = me->catalog
      exceptions
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        others                        = 4 ).
  endmethod.

  method set_field_catalog.
    me->catalog = catalog.
    set handler handle_hotspot_click for me->grid.
  endmethod.

  method set_layout.
    me->layout = layout.
  endmethod.

  method handle_hotspot_click.
    data(column_id) = to_upper( conv string( e_column_id-fieldname ) ).
    data(row_id) = e_row_id-index.

    if column_id = 'HOTSPOT_SHOW'.
      data(object) = get_clicked_row( row_id ).
      gui->show_results_for( object ).
    endif.
  endmethod.

  method set_lines.
    me->lines = lines.
  endmethod.

  method get_clicked_row.
    result = lines[ row_index ].
  endmethod.

endclass.