INTERFACE zif_oo_plugin PUBLIC.

  CONSTANTS: plugin_interface TYPE seoclsname VALUE `ZIF_OO_PLUGIN`.

  TYPES:
    BEGIN OF t_plugin_info,
      id          TYPE string,
      category    TYPE string,
      class_name  TYPE seoclsname,
      description TYPE string,
    END OF t_plugin_info,
    tt_plugin_info TYPE HASHED TABLE OF t_plugin_info WITH UNIQUE KEY id.

  METHODS get_info RETURNING VALUE(result) TYPE t_plugin_info.
  METHODS is_enabled RETURNING VALUE(result) TYPE abap_bool.

ENDINTERFACE.
