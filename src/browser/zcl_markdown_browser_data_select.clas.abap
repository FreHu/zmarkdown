class zcl_markdown_browser_data_select definition
  public final.

  public section.

    methods single_object
      importing object_type   type tadir-object
                object_name   type tadir-obj_name
      returning value(result) type zif_markdown_docu_browser_types=>t_objects.

    methods multiple_objects
      importing object_types  type zif_markdown_docu_browser_types=>t_selection-object_types
                object_names  type zif_markdown_docu_browser_types=>t_selection-object_names
      returning value(result) type zif_markdown_docu_browser_types=>t_objects.

    methods package
      importing package_name  type devclass
      returning value(result) type zif_markdown_docu_browser_types=>t_objects.

  protected section.
  private section.

    methods get_subpackages
      importing root_package   type devclass
      returning value(results) type zif_markdown_docu_browser_types=>t_packages.

endclass.



class zcl_markdown_browser_data_select implementation.

  method multiple_objects.
    select * from tadir
      where obj_name in @object_names
      and object in @object_types
    into table @result.
  endmethod.

  method single_object.

    data(type_range) = new zcl_markdown_browser_range(
      )->single_object( conv #( object_type ) )->get( ).

    data(name_range) = new zcl_markdown_browser_range(
      )->single_object( conv #( object_name ) )->get( ).

    result = multiple_objects(
      object_types = conv #( type_range )
      object_names = conv #( name_range ) ).

  endmethod.

  method package.

    data(package_list) = value zif_markdown_docu_browser_types=>t_packages( ( package_name ) ).
    append lines of get_subpackages( package_name ) to package_list.

    data(package_range) = new zcl_markdown_browser_range(
    )->single_objects( conv #( package_list ) )->get( ).

    select * from tadir
      where devclass in @package_range
    into table @result.

  endmethod.

  method get_subpackages.

    select devclass from tdevc where parentcl = @root_package
    into table @results.

    loop at results assigning field-symbol(<subpackage>).
      append lines of get_subpackages( <subpackage> ) to results.
    endloop.

  endmethod.

endclass.
