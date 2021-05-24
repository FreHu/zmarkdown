INTERFACE zif_oo_plugin_object_info PUBLIC.

  INTERFACES: zif_oo_plugin.

  TYPES: t_content_type TYPE string.
  CONSTANTS: category TYPE string VALUE `OBJECT_INFO`.

  METHODS display
    IMPORTING
      object_type TYPE tadir-object
      object_name TYPE tadir-obj_name
      gui_control TYPE REF TO cl_gui_html_viewer.

ENDINTERFACE.
