interface zif_markdown_docu_browser_types public.

  types:
    begin of t_selection,
      object_types type range of tadir-object,
      object_names type range of tadir-obj_name,
    end of t_selection.

  types t_objects type standard table of tadir
    with key object obj_name devclass.

  types t_packages type standard table of devclass with key table_line.

  types:
    begin of t_grid_line,
      object_type  type tadir-object,
      object_name  type tadir-obj_name,
      hotspot_show type string,
    end of t_grid_line,
    t_grid_lines type standard table of t_grid_line with empty key.

  types:
    begin of t_object_result,
      object_type  type tadir-object,
      object_name  type tadir-object,
      html_results type string,
    end of t_object_result,
    t_object_result_map type hashed table of t_object_result with unique key object_type object_name.

endinterface.
