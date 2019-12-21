
import math, tables, strutils, options, sequtils, os, npeg
import ../lib/intcode

var
  input = readLines("input")[0].split(",").map(parseInt)

proc go(program: string): int =
  let cpu = newCpu(input)
  for c in program:
      cpu.send some c.int

  while true:
    let c = cpu.runRecv()
    if c == 0:
      break
    if c > 255:
      return c
    stdout.write(c.char)

let part1 = go """
NOT A J
NOT B T
OR T J
NOT C T
OR T J
AND D J
WALK
"""

let part2 = go """
NOT B J
NOT C T
OR T J
AND H J
NOT A T
OR T J
AND D J
RUN
"""

echo "part1: ", part1
echo "part12 ", part2
