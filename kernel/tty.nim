type
  VIDMem* = ptr array[0..65_000, Entry]
  VGAColor* = enum
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGrey = 7,
    DarkGrey = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    LightMagenta = 13,
    Yellow = 14,
    White = 15
  Pos* = tuple[x: int, y: int]
  Attribute* = distinct uint8
  Entry* = distinct uint16

const
  VGAWidth* = 80
  VGAHeight* = 25

var
  VGABuffer: VIDMem = nil

var
  lastPos: Pos = (0, 0)

proc initTTY*(buffer: VIDMem) =
  VGABuffer = buffer

proc makeColor*(bg: VGAColor, fg: VGAColor): Attribute =
  ## Combines a foreground and background color into a ``TAttribute``.
  return (ord(fg).uint8 or (ord(bg).uint8 shl 4)).Attribute

proc makeEntry*(c: char, color: Attribute): Entry =
  ## Combines a char and a *TAttribute* into a format which can be
  ## directly written to the Video memory.
  let c16 = ord(c).uint16
  let color16 = color.uint16
  return (c16 or (color16 shl 8)).Entry

proc writeChar*(vram: VidMem, entry: Entry, pos: Pos) =
  ## Writes a character at the specified ``pos``.
  let index = (80 * pos.y) + pos.x
  vram[index] = entry

proc newLine* = 
  lastPos.x = 0
  lastPos.y += 1

proc writeChar*(entry: Entry, pos: Pos) =
  writeChar(VGABuffer, entry, pos)

proc writeChar*(chr: char, attr: Attribute) = 
  if chr == '\n':
    newLine()
  else:
    if lastPos.x >= VGAWidth:
      newLine()
    
    writeChar(makeEntry(chr, attr), lastPos)
    lastPos.x += 1

proc rainbow*(vram: VidMem, text: string, pos: Pos) =
  ## Writes a string at the specified ``pos`` with varying colors which, despite
  ## the name of this function, do not resemble a rainbow.
  var colorBG = DarkGrey
  var colorFG = Blue
  proc nextColor(color: VGAColor, skip: set[VGAColor]): VGAColor =
    if color == White:
      result = Black
    else:
      result = (ord(color) + 1).VGAColor
    if result in skip: result = nextColor(result, skip)
  
  for i in 0 .. text.len-1:
    colorFG = nextColor(colorFG, {Black, Cyan, DarkGrey, Magenta, Red,
                                  Blue, LightBlue, LightMagenta})
    let attr = makeColor(colorBG, colorFG)
    
    vram.writeChar(makeEntry(text[i], attr), (pos.x+i, pos.y))

proc rainbow*(text: string, pos: Pos) =
  rainbow(VGABuffer, text, pos)

proc writeString*(vram: VidMem, text: string, color: Attribute, pos: Pos) =
  ## Writes a string at the specified ``pos`` with the specified ``color``.
  for i in 0 .. text.len-1:
    vram.writeChar(makeEntry(text[i], color), (pos.x+i, pos.y))

proc writeString*(text: string, color: Attribute, pos: Pos) =
  writeString(VGABuffer, text, color, pos)

proc writeString*(text: string, color: Attribute) = 
  for chr in text:
    writeChar(chr, color)

proc screenClear*(video_mem: VidMem, color: VGAColor) =
  ## Clears the screen with a specified ``color``.
  let attr = makeColor(color, color)
  let space = makeEntry(' ', attr)
  
  var i = 0
  while i <=% VGAWidth*VGAHeight:
    video_mem[i] = space
    inc(i)