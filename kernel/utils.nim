import tty

import strutils, macros


proc printImpl(objects: openarray[string], clr = makeColor(Black, White), sep=" ", endl="\n") =
  # Write all objects joined by sep
  writeString(objects.join(sep), clr)
  # Write end of line
  writeString(endl, clr)
  # If flush is needed, flush the file

macro print*(data: varargs[untyped]): untyped =
  ## Print macro identical to Python "print()" function with
  ## one change: end argument was renamed to endl
  let printProc = bindSym("printImpl")
  var objects = newTree(nnkBracket)
  var arguments = newTree(nnkArglist)
  for arg in data:
    if arg.kind == nnkExprEqExpr:
      # Add keyword argument
      arguments.add(arg)
    else:
      # Add object and stringify it automatically
      objects.add(newCall("$", arg))
  # XXX: Do we need to convert objects to sequence?
  # objects = prefix(objects, "@")
  result = quote do:
    `printProc`(`objects`, `arguments`)