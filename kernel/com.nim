# https://wiki.osdev.org/Serial_Ports
import io

const
  Com1 = 0x3f8
#[
{.push stackTrace:off.}
proc outb(port: uint16, val: uint8) = 
    asm """
      outb `port`, `val`
    """

proc inb(port: uint16): uint8 = 
  asm """
    inb `port`, `result`
  """
]#
proc initSerial* = 
  out8(Com1 + 1, 0x00) # Disable all interrupts
  out8(Com1 + 3, 0x80) # Enable DLAB (set baud rate divisor)
  out8(Com1 + 0, 0x03) # Set divisor to 3 (lo byte) 38400 baud
  out8(Com1 + 1, 0x00) # (hi byte)
  out8(Com1 + 3, 0x03) # 8 bits, no parity, one stop bit
  out8(Com1 + 2, 0xC7) # Enable FIFO, clear them, with 14-byte threshold
  out8(Com1 + 4, 0x0B) # IRQs enabled, RTS/DSR set

proc isTransmitEmpty: uint8 = 
  in8(Com1 + 5) and 0x20

proc writeSerial*(a: char) = 
  while isTransmitEmpty() == 0: discard

  out8(Com1, uint8(a))

proc writeSerial*(a: string) = 
  for chr in a:
    writeSerial(chr)

template debug*(code: untyped) = 
  writeSerial("\n---\n")
  writeSerial("before code\n")
  writeSerial(astToStr(code))
  writeSerial('\n')
  code
  writeSerial("\nafter code\n")
  writeSerial("---\n")