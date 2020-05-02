import tty
import com
import libc/libc
import cpuid
import tables
import utils

type
  TMultiboot_header = object
  PMultiboot_header = ptr TMultiboot_header

var
  vram = cast[VIDMem](0xB8000)

proc nomem = 
  writeSerial("apparently we're out of memory now")

outOfMemHook = nomem

proc kmain(mb_header: PMultiboot_header, magic: int) {.exportc.} =
  if magic != 0x1BADB002:
    discard # Something went wrong?
  
  initSerial()
  initTTY(vram)
  screenClear(vram, Black) # Make the screen yellow.


  debug: 
    var a = @[1, 2, 3]
  debug:
    a.add 5
  debug:
    writeSerial($a)
  try:
    let b = a[5]
    writeSerial($b)
  except:
    writeSerial("caught\n")
  print "Nim", NimVersion
  print "Expressive. Efficient. Elegant."
  print "It's pure pleasure.", clr = makeColor(Black, Yellow)
  debug:
    var ab = newTable[string, string]()
  debug:
    ab["hello"] = "world"
  debug:
    print ab["hello"]
