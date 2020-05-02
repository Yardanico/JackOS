import com

proc rawoutput*(s: string) =
  writeSerial("unhandled error:\n")
  writeSerial(s)
  writeSerial('\n')

proc panic*(s: string) =
  writeSerial("panic!\n")
  rawoutput(s)

# Alternatively we also could implement these 2 here:
#
# template sysFatal(exceptn: typeDesc, message: string)
# template sysFatal(exceptn: typeDesc, message, arg: string)