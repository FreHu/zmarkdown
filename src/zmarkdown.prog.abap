REPORT zmarkdown.

DATA(demo) = NEW zcl_markdown_demo( ).
cl_demo_output=>display_text( demo->get( ) ).

DATA(class_docu) = NEW zcl_markdown_docu_clas(
  class_name = `ZCL_MARKDOWN_DOCU_CLAS`
  document = NEW zcl_markdown( ) ).
cl_demo_output=>display_text( class_docu->doc->content ).

class_docu = NEW zcl_markdown_docu_clas(
  class_name = `ZCL_MARKDOWN_DOCU_CLAS`
  document = NEW zcl_markdown_html( ) ).
cl_demo_output=>display_html(
  zcl_markdown_html=>html(
  zcl_markdown_html=>body( class_docu->doc->content ) ) ).
