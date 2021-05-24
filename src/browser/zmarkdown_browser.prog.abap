REPORT zmarkdown_browser.

TABLES tadir.
INCLUDE zmarkdown_browser_screen.

START-OF-SELECTION.
  DATA: modes TYPE zcl_oo_plugin_provider=>tt_implementations.
  PERFORM everything.

INITIALIZATION.
  TRY.
      modes = zcl_oo_plugin_provider=>get_enabled( zif_oo_plugin_object_info=>category ).
      p_mode = modes[ 1 ]-info-id.
    CATCH cx_root.
      MESSAGE 'No plugin implementations found' TYPE 'S' DISPLAY LIKE 'E'.
      RETURN.
  ENDTRY.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_mode.

  DATA: listbox_values TYPE vrm_values.
  listbox_values = VALUE #( FOR <x> IN modes (
    key = <x>-instance->get_info( )-id
    text = <x>-instance->get_info( )-description ) ).

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'P_MODE'
      values          = listbox_values
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.


FORM everything.

  DATA(objects) = VALUE zif_markdown_browser_types=>t_objects( ).
  DATA(select) = NEW zcl_markdown_browser_select( ).
  IF x_one = abap_true.
    objects = select->single_object(
      object_type = p_type
      object_name = p_name ).
  ELSEIF x_more = abap_true.
    objects = select->multiple_objects(
      object_types = s_type[]
      object_names = s_name[] ).
  ELSEIF x_pkg = abap_true.
    IF p_pkg IS INITIAL.
      MESSAGE 'Provide a package' TYPE 'S' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.
    objects = select->package( package_name = p_pkg ).
  ENDIF.

  IF objects IS INITIAL.
    MESSAGE 'Selection empty' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ELSE.
    DATA(gui) = NEW zcl_markdown_browser_gui(
      program = sy-repid
      screen_number = '0999'
      objects = objects
      mode_id = CONV #( p_mode ) ).

    CALL SCREEN 0999.
  ENDIF.

ENDFORM.

END-OF-SELECTION.

MODULE status_0999 OUTPUT.
  SET PF-STATUS 'RESULTS'.
ENDMODULE.

MODULE user_command_0999 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
