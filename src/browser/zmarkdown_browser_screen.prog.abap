SELECTION-SCREEN BEGIN OF BLOCK mode
  WITH FRAME TITLE TEXT-003.

  PARAMETERS:
    x_pkg  RADIOBUTTON GROUP fsrc  DEFAULT 'X' USER-COMMAND sel_mode,
    x_one  RADIOBUTTON GROUP fsrc,
    x_more RADIOBUTTON GROUP fsrc.

SELECTION-SCREEN END OF BLOCK mode.

SELECTION-SCREEN BEGIN OF BLOCK b_single
  WITH FRAME TITLE TEXT-001.

  PARAMETERS:
    p_type LIKE tadir-object MODIF ID sgl,
    p_name LIKE tadir-obj_name MODIF ID sgl.

SELECTION-SCREEN END OF BLOCK b_single.

SELECTION-SCREEN BEGIN OF BLOCK b_multiple
  WITH FRAME TITLE TEXT-002.

  SELECT-OPTIONS:
      s_type FOR tadir-object MODIF ID mtp,
      s_name FOR tadir-obj_name MODIF ID mtp.

SELECTION-SCREEN END OF BLOCK b_multiple.

SELECTION-SCREEN BEGIN OF BLOCK b_package
  WITH FRAME TITLE TEXT-004.

  PARAMETERS:
       p_pkg LIKE tdevc-devclass MODIF ID pkg.

SELECTION-SCREEN END OF BLOCK b_package.

SELECTION-SCREEN BEGIN OF BLOCK b_mode
  WITH FRAME TITLE TEXT-005.

  PARAMETERS:
    p_mode TYPE c LENGTH 30 AS LISTBOX VISIBLE LENGTH 30.

SELECTION-SCREEN END OF BLOCK b_mode.


AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN INTO DATA(wa).
    CASE wa-group1.
      WHEN 'SGL'.
        IF x_one = abap_false.
          wa-active = '0'.
          MODIFY SCREEN.
          CONTINUE.
        ENDIF.
      WHEN 'MTP'.
        IF x_more = abap_false.
          wa-active = '0'.
          MODIFY SCREEN.
          CONTINUE.
        ENDIF.
      WHEN 'PKG'.
        IF x_pkg = abap_false.
          wa-active = '0'.
          MODIFY SCREEN.
          CONTINUE.
        ENDIF.
    ENDCASE.
  ENDLOOP.
