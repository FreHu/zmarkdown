CLASS zcx_markdown DEFINITION
  PUBLIC FINAL
  INHERITING FROM cx_no_check.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING reason   TYPE string
                previous TYPE REF TO cx_root OPTIONAL.

    DATA reason TYPE string READ-ONLY.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_markdown IMPLEMENTATION.
  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).
    me->reason = reason.
  ENDMETHOD.

ENDCLASS.
