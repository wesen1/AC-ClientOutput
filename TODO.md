
# TODOs

## Add option to configure the minimum space between columns in pixels

* Branch: feature/add-min-space-between-columns-option


## Allow rendering of ClientOutput's with multiple fonts

* SymbolWidthLoader should load all font configs at once and allow to choose a font config when loading the character width
* ClientOutput's should have a default font and have a parameter to pick a different font than that


## Use all available pixels for ClientOutputTable outputs

Pixels after the last passed tab stop of the maximum line width must be taken into account.

Either:
* The last column fits into the number of pixels
  * If necessary the last column can be reduced to 0 tab stops + the pixel width
* The last column does not fit into the number of pixels
  * Extend the last column by the number of pixels


## Add unit tests for all classes

- [ ] ClientOutputFactory
- [ ] ClientOutputConfiguration

*ClientOutputString*
- [ ] ClientOutputString (includes testing of BaseClientOutput)
- [ ] StringWidthCalculator
- [ ] StringSplitter
- [ ] StringParser
- [ ] ParsedString
- [ ] RowBuilder
- [ ] RowDimensionsCalculator
- [ ] WidthCacher

*ClientOutputTable*
- [ ] ClientOutputTable (includes testing of BaseClientOutput)
- [ ] ClientOutputTableConfiguration
- [x] TableParser
- [ ] ParsedTable
- [ ] TableRenderer

*Util*
- [x] SymbolWidthLoader
- [x] TabStopCalculator


## Add integration tests for ClientOutputFactory

## Add option to abbreviate output lines with "..." if they execeed the maximum width

## Add AC lua server test script that checks the output width and tab stop positions

* It should provide a minimum CommandParser
* A Command like "!checkOutput" should be available
  * Parameters: "distanceToNextTabStop", "font"
  * Generates texts with that distance to the next tab stop and places "\t|->" behind the text
  * Must have some hardcoded maximum line width


## Throw Exception when minimum width is lower than new line indent width + widest possible character width

Also add a option to trim the row indent instead of throwing the exception.

* line indent width + character width of any of the characters in the output


# Ideas

- ClientOutputTable: Cell text align (left, center, right)
