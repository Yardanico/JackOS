import tty
import com
import cpuid as cpuid

type
  TMultiboot_header = object
  PMultiboot_header = ptr TMultiboot_header

var
  vram = cast[PVIDMem](0xB8000)

proc kmain(mb_header: PMultiboot_header, magic: int) {.exportc.} =
  if magic != 0x2BADB002:
    discard # Something went wrong?

  initTTY(vram)
  screenClear(vram, LightBlue) # Make the screen yellow.

  # Demonstration of error handling.
  # var x = len(vram[])
  # var outOfBounds = vram[x]

  let attr = makeColor(LightBlue, White)
  #let info = cpu_info()
  #writeString(info.vendor_id, attr, (0, 0))
  debug: 
    var a = "hello "
  debug:
    var b = "world\n"
  debug:
    writeSerial(a & b)
  debug: 
    var c = @[1, 2, 3]
  debug: 
    c.add 5
  debug:
    writeSerial("c is - " & $c)
  writeString("Nim", attr, (25, 9))

  writeString("Expressive. Efficient. Elegant.", attr, (25, 11))
  rainbow("It's pure pleasure.", (x: 25, y: 12))

