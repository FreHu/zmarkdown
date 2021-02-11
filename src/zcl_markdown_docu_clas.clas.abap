CLASS zcl_markdown_docu_clas DEFINITION PUBLIC
  INHERITING FROM zcl_markdown_data.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING class_name TYPE seoclsname.

  PRIVATE SECTION.
    DATA: descr TYPE REF TO cl_abap_classdescr.
    METHODS attributes.

ENDCLASS.



CLASS zcl_markdown_docu_clas IMPLEMENTATION.

  METHOD constructor.

    super->constructor( ).
    me->descr = CAST #( cl_abap_classdescr=>describe_by_name( class_name ) ).

    heading( level = 1 val = me->descr->get_relative_name( ) ).

    IF descr->interfaces IS NOT INITIAL.
      heading( level = 2 val = `Interfaces` ).
      data_table( data = descr->interfaces auto_header_row = abap_false ).
    ENDIF.

    IF descr->types IS NOT INITIAL.
      heading( level = 2 val = `Types` ).
      data_table( data = descr->types auto_header_row = abap_false ).
    ENDIF.

    IF descr->methods IS NOT INITIAL.
      heading( level = 2 val = `Methods` ).
      LOOP AT descr->methods ASSIGNING FIELD-SYMBOL(<method>).
        DATA(method_md) = NEW zcl_markdown_docu_meth( class_name = class_name descr = <method> ).
        text( method_md->as_markdown( ) ).
      ENDLOOP.
    ENDIF.

    attributes( ).

  ENDMETHOD.

  METHOD attributes.

    IF descr->attributes IS NOT INITIAL.
      heading( level = 2 val = `Attributes` ).
      TYPES:
        BEGIN OF t_attribute,
          name         TYPE string,
          type_kind    TYPE string,
          visibility   TYPE string,
          is_inherited TYPE string,
          is_class     TYPE string,
          is_read_only TYPE string,
        END OF t_attribute,
        t_attributes TYPE STANDARD TABLE OF t_attribute WITH DEFAULT KEY.

      DATA: attributes TYPE t_attributes.
      LOOP AT descr->attributes ASSIGNING FIELD-SYMBOL(<attr>)
        WHERE is_constant = abap_true. " constants
        APPEND VALUE #(
          name = <attr>-name
          type_kind = <attr>-type_kind
          visibility = <attr>-visibility
          is_inherited = <attr>-is_inherited
          is_class = <attr>-is_class
          is_read_only = <attr>-is_class
        ) TO attributes.
      ENDLOOP.

      IF attributes IS NOT INITIAL.
        heading( level = 3 val = 'Constants' ).
        data_table( attributes ).
        CLEAR attributes.
      ENDIF.

      LOOP AT descr->attributes ASSIGNING <attr>
        WHERE is_class = abap_true AND is_constant = abap_false.
        APPEND VALUE #(
          name = <attr>-name
          type_kind = <attr>-type_kind
          visibility = <attr>-visibility
          is_inherited = <attr>-is_inherited
          is_read_only = <attr>-is_class
        ) TO attributes.

      ENDLOOP.

      IF attributes IS NOT INITIAL.
        heading( level = 3 val = 'Class Attributes' ).
        data_table( attributes ).
        CLEAR attributes.
      ENDIF.

      LOOP AT descr->attributes ASSIGNING <attr>
        WHERE is_class = abap_false AND is_constant = abap_false.
        APPEND VALUE #(
          name = <attr>-name
          type_kind = <attr>-type_kind
          visibility = <attr>-visibility
          is_inherited = <attr>-is_inherited
          is_read_only = <attr>-is_class
        ) TO attributes.

      ENDLOOP.

      IF attributes IS NOT INITIAL.
        heading( level = 3 val = 'Member Attributes' ).
        data_table( attributes ).
        CLEAR attributes.
      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
