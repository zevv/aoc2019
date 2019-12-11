
import math, tables, strutils, options, sequtils
import ../lib/intcode
import ../lib/sparsemap

proc paint(i: int): (string, int) =

  var
    input = readLines("input")[0].split(",").map(parseInt)
    map: SparseMap[int]
    cpu = newCpu(input)
    (x, y, d) = (0, 0, 0)
    sintab = [-1, 0, 1, 0] # Sine table :)

  map.set(0, 0, i)

  while cpu.tick():
    cpu.send some map.get(x, y)
    map.set x, y, cpu.runRecv()
    inc d, cpu.runRecv() * 2 - 1
    inc x, sintab[ (d+1) %% 4 ]
    inc y, sintab[ (d+0) %% 4 ]

  result = ("\n" & $map, map.count)

let (_, part1) = paint(0)
let (part2, _) = paint(1)

echo "part1: ", part1
echo "part2: ", part2
