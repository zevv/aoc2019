
import math, tables, strutils, options, sequtils, os, sugar
import ../lib/intcode
import ../lib/sparsemap

type Tile = enum Empty, Wall, Block, Paddle, Ball
const cs = " #=O-"

proc play(part: int): int =

  var input = readLines("input")[0].split(",").map(parseInt)

  if part == 2:
    input[0] = 2 # Play for free!

  var
    cpu = newCpu(input)
    paddle = 0
    map: SparseMap[Tile]

  while cpu.tick():

    let (x, y, v) = (cpu.runRecv(), cpu.runRecv(), cpu.runRecv())

    if x == -1:
      result = v
    else:
      map.set(x, y, v.Tile)
      case v.Tile
        of Paddle:
          paddle = x
        of Ball:
          cpu.send some cmp(x, paddle)
          if paramCount() > 0:
            echo map.draw(proc(v: Tile): char = cs[v.int]), result
        else:
          discard

  if part == 1:
    result = map.count(Block)

echo "part1: ", play(1)
echo "part2: ", play(2)
