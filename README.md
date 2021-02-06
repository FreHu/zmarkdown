# zmarkdown
Markdown generator

Early draft, I would not start depending on this yet if I were you.

## Purpose and motivation

I needed a valid reason to name a method `_____________________________`.

## Example Usage

This code will generate the markdown rendered below it.

```abap    md = NEW zcl_markdown( ).
    DATA(style) = md->style.

    md = md->heading( level = 1 val = |Markdown generator - showcase| ).

    DO 6 TIMES.
      md = md->heading( level = sy-index val = |Heading { sy-index }| ).
    ENDDO.

    md->text( 'This is text.'
      )->text( style->bold( 'This is bold text.' )
      )->text( style->italic( 'This is italic text.' )
      )->text( style->italic_bold( `This is italic bold text.` )
      )->text( style->bold_italic( `This is bold italic text. Carefully note the difference.` )

      )->text( |{ style->italic( 'This is italic' ) } and { style->bold( 'this is bold.' ) }|
      )->text( |The method { style->inline_code( 'zcl_mardown_style->inline_code' ) } outputs inline code.|

      )->heading( level = 2 val = `Blockquotes`
        )->blockquote( md->document

      )->heading( level = 2 val = `Nested Blockquotes`
        )->blockquote( md->document

      )->heading( level = 2 val = `Unordered Lists`
        )->list( VALUE stringtab(
          ( `Item 1` )
          ( `Item 2` )
          ( `Item 3` ) )

      )->heading( level = 2 val = `Numbered Lists`
        )->numbered_list( VALUE stringtab(
          ( `Item 1` )
          ( `Item 2` )
          ( `Item 3` ) )
      )->heading( level = 2 val = `Horizontal Rule`

      )->______________________________(

      )->heading( level = 2 val = `Code blocks`
      )->code_block(
        |md = md && list( VALUE stringtab(\r\n| &
        |  ( `Item 1` )\r\n| &
        |  ( `Item 2` )\r\n| &
        |  ( `Item 3` )\r\n| &
        |) ).\r\n| &
        |\r\n| &
        |md = md && numbered_list( VALUE stringtab(\r\n| &
        |  ( `Item 1` )\r\n| &
        |  ( `Item 2` )\r\n| &
        |  ( `Item 3` )\r\n| &
        |) ).|
    )->table( VALUE stringtab(
      ( `col1;col2;col3;col4;` )
      ( `a;b;c;d` )
      ( `1;2;3;4;`)
      ( `e;f;g;h;` )
      ( |{ style->bold( `bold` ) };{ style->italic( `italic` ) };{ style->bold_italic( `bold_italic` ) }{ style->inline_code( `code` ) };;| )
    ) ).
```

# Markdown generator - showcase
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6
This is text.
**This is bold text.**
*This is italic text.*
***This is italic bold text.***
***This is bold italic text. Carefully note the difference.***
*This is italic* and **this is bold.**
The method `zcl_mardown_style->inline_code` outputs inline code.
## Blockquotes
> # Markdown generator - showcase
> # Heading 1
> ## Heading 2
> ### Heading 3
> #### Heading 4
> ##### Heading 5
> ###### Heading 6
> This is text.
> **This is bold text.**
> *This is italic text.*
> ***This is italic bold text.***
> ***This is bold italic text. Carefully note the difference.***
> *This is italic* and **this is bold.**
> The method `zcl_mardown_style->inline_code` outputs inline code.
> ## Blockquotes
## Nested Blockquotes
> # Markdown generator - showcase
> # Heading 1
> ## Heading 2
> ### Heading 3
> #### Heading 4
> ##### Heading 5
> ###### Heading 6
> This is text.
> **This is bold text.**
> *This is italic text.*
> ***This is italic bold text.***
> ***This is bold italic text. Carefully note the difference.***
> *This is italic* and **this is bold.**
> The method `zcl_mardown_style->inline_code` outputs inline code.
> ## Blockquotes
> > # Markdown generator - showcase
> > # Heading 1
> > ## Heading 2
> > ### Heading 3
> > #### Heading 4
> > ##### Heading 5
> > ###### Heading 6
> > This is text.
> > **This is bold text.**
> > *This is italic text.*
> > ***This is italic bold text.***
> > ***This is bold italic text. Carefully note the difference.***
> > *This is italic* and **this is bold.**
> > The method `zcl_mardown_style->inline_code` outputs inline code.
> > ## Blockquotes
> ## Nested Blockquotes
## Unordered Lists
- Item 1
- Item 2
- Item 3
## Numbered Lists
1. Item 1
2. Item 2
3. Item 3
## Horizontal Rule
__________ 
## Code blocks
```abap
md = md && list( VALUE stringtab(
  ( `Item 1` )
  ( `Item 2` )
  ( `Item 3` )
) ).

md = md && numbered_list( VALUE stringtab(
  ( `Item 1` )
  ( `Item 2` )
  ( `Item 3` )
) ).
```
| col1| col2| col3| col4 |
|------|------|------|------| 
| a | b | c | d |
| 1 | 2 | 3 | 4 |
| e | f | g | h |
| **bold** | *italic* | ***bold_italic*** | `code` |
