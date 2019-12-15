
import math, tables, strutils, options, sequtils, os, npeg, random
import ../lib/intcode
import ../lib/sparsemap

var
  input = readLines("input")[0].split(",").map(parseInt)
  cpu = newCpu(input)
  map: SparseMap[int]
  part1, part2: int

var dir: array[1..4, (int, int)] = [(0,-1), (0,1), (-1,0), (1,0)]

# Recursivly walk the map, each step the CPU state is cloned
# to allow backtracking

proc step(cpu: Cpu, x, y, d: int) =

  proc test(dir, x, y: int) =
    if map.get(x, y) == 0:
      let cpu = cpu.copy()
      cpu.send some dir
      let c = cpu.runRecv()
      map.set(x, y, c)
      if c == 2: part1 = d 
      if c != 0: step(cpu, x, y, d+1)

  for i, (dx, dy) in dir:
    test(i, x+dx, y+dy)
   
step(cpu, 0, 0, 1)

# Flood fill the map from the oxygen station

for i in 0..int.high:
  var map2 = map
  for (x, y, v) in map:
    if v == 2:
      for i, (dx, dy) in dir:
        if map.get(x+dx, y+dy) == 1:
          map2.set(x+dx, y+dy, 2)
  if map.count(1) == 0:
    part2 = i
    break
  map = map2

echo "part1: ", part1
echo "part2: ", part2
