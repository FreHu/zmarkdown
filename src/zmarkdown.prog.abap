REPORT zmarkdown.

 DATA(class_1) = NEW zcl_markdown_docu_clas( `ZCL_MARKDOWN` )->as_markdown( ).
 DATA(class_2) = NEW zcl_markdown_docu_clas( `ZCL_MARKDOWN_DATA` )->as_markdown( ).
 DATA(class_3) = NEW zcl_markdown_docu_clas( `ZCL_MARKDOWN_DOCU_CLAS` )->as_markdown( ).
 DATA(class_4) = NEW zcl_markdown_docu_clas( `ZCL_MARKDOWN_DOCU_METH` )->as_markdown( ).

 cl_demo_output=>write_text( class_1 ).
 cl_demo_output=>write_text( class_2 ).
 cl_demo_output=>write_text( class_3 ).
 cl_demo_output=>write_text( class_4 ).
