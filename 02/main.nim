import strutils, sequtils

type
  Program = seq[int]

  Opcode = enum
    opAdd = 1,
    opMul = 2,
    opBye = 99

template op: Opcode = p[ip].Opcode
template r(off): int = p[p[ip+off]]

func run(p: var Program): int =
  var ip = 0
  while true:
    case op:
      of opAdd: r(3) = r(1) + r(2)
      of opMul: r(3) = r(1) * r(2)
      of opBye: break
    ip += 4
  result = p[0]

let input = readLines("input")[0].split(",").map(parseInt)

block:
  var p = input
  (p[1], p[12]) = (12, 2)
  echo "part1: ", p.run()

block:
  for i in 0..99:
    for j in 0..99:
      var p = input
      (p[1], p[2]) = (i, j)
      if p.run() == 19690720:
        echo "part2: ", i*100 + j


