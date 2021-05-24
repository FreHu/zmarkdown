CLASS zcl_oo_plugin_provider DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF t_implementation,
        info     TYPE zif_oo_plugin=>t_plugin_info,
        instance TYPE REF TO zif_oo_plugin,
      END OF t_implementation,
      tt_implementations TYPE SORTED TABLE OF t_implementation WITH UNIQUE KEY info.

    CLASS-METHODS get_all
      IMPORTING
        category       TYPE zif_oo_plugin=>t_plugin_info-category
      RETURNING
        VALUE(results) TYPE tt_implementations.

    CLASS-METHODS get_by_id
      IMPORTING
        category       TYPE zif_oo_plugin=>t_plugin_info-category
        id             TYPE zif_oo_plugin=>t_plugin_info-id
      RETURNING
        VALUE(results) TYPE t_implementation.


    CLASS-METHODS get_enabled
      IMPORTING
        category       TYPE zif_oo_plugin=>t_plugin_info-category
      RETURNING
        VALUE(results) TYPE tt_implementations.

    CLASS-DATA: cache TYPE tt_implementations.

ENDCLASS.


CLASS zcl_oo_plugin_provider IMPLEMENTATION.

  METHOD get_all.

    IF cache IS NOT INITIAL.
      results = cache.
      RETURN.
    ENDIF.

    TRY.
        DATA: impl TYPE REF TO zif_oo_plugin.
        DATA(intf) = NEW cl_oo_interface( zif_oo_plugin=>plugin_interface ).
        DATA(implementations) = intf->get_implementing_classes( ).
        LOOP AT implementations ASSIGNING FIELD-SYMBOL(<impl>).
          CREATE OBJECT impl TYPE (<impl>-clsname).
          DATA(info) = impl->get_info( ).
          IF info-category = category.
            INSERT VALUE #(
              info = impl->get_info( )
              instance = impl ) INTO TABLE results.
          ENDIF.
        ENDLOOP.
      CATCH cx_root.
    ENDTRY.

    cache = results.
  ENDMETHOD.

  METHOD get_enabled.
    DATA(all) = get_all( category ).
    LOOP AT all ASSIGNING FIELD-SYMBOL(<one>).
      IF <one>-instance->is_enabled( ).
        INSERT <one> INTO TABLE results.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_by_id.
    TRY.
        DATA(sane_category) = to_upper( condense( category ) ).
        DATA(sane_id) = to_upper( condense( id ) ).
        results = cache[ info-category = sane_category info-id = sane_id ].
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
