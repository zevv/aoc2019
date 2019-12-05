import strutils, sequtils, math, tables

type
  Program = seq[int]

  Opcode = enum
    opAdd = 1,
    opMul = 2,
    opIn  = 3,
    opOut = 4,
    opJt  = 5,
    opJf  = 6,
    opLt  = 7,
    opEq  = 8,
    opBye = 99,

let opLen = [ 0, 4, 4, 2, 2, 3, 3, 4, 4 ]

template op: Opcode = (p[ip] mod 100).Opcode
template rImm(off): int = p[ip+off]
template rPos(off): int = p[p[ip+off]]

template r(off): int =
  if ((p[ip] div 10^(off+1)) mod 10) != 0:
    rImm(off)
  else:
    rPos(off)

proc run(pIn: Program, input: varargs[int]): int =
  var (p, ip, inx) = (pIn, 0, 0)
  while true:
    case op:
      of opAdd:
        rPos(3) = r(1) + r(2)
      of opMul:
        rPos(3) = r(1) * r(2)
      of opIn:
        rPos(1) = input[inx]
        inc inx
      of opOut:
        result = r(1)
      of opJt:
        if r(1) != 0:
          ip = r(2)
          continue
      of opJf:
        if r(1) == 0:
          ip = r(2)
          continue
      of opLt:
        rPos(3) = int(r(1) < r(2))
      of opEq:
        rPos(3) = int(r(1) == r(2))
      of opBye:
        break
    inc ip, oplen[op.int]

let input = readLines("input")[0].split(",").map(parseInt)
echo "part1: ", run(input, 1)
echo "part2: ", run(input, 5)
