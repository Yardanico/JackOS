{.push used, exportc.}
include string
import ../com
var heap = cast[pointer](50000000)

proc calloc*: pointer = 
  heap

proc signal*: int = 
  1

proc fflush*: int = 
  1

proc memset*(a: pointer, val: int, size: csize_t) = 
  writeSerial("doing memset\n")
  var a2 = cast[ptr UncheckedArray[int]](a)
  for i in 0 ..< size:
    a2[i] = val

proc malloc*(size: csize_t): pointer = 
  writeSerial("doing malloc\n")
  result = cast[pointer](heap)
  heap = cast[pointer](cast[csize_t](heap) + size)

proc realloc*(a: pointer, size: csize_t): pointer = 
  writeSerial("doing realloc\n")
  result = malloc(size)

proc memcpy*(dst, src: ptr, size: csize_t): ptr =
  writeSerial("doing memcpy\n")
  for i in 0..size:
    dst[i] = src[i]
  result = dst

proc exit* = 
  discard

proc free*(a: pointer) = 
  discard

{.pop.}