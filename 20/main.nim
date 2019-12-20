
import math, tables, strutils, options, sequtils, os, npeg
import ../lib/intcode
import ../lib/sparsemap

var map: SparseMap[char]
var w, h: int
var part1, part: int

let input = readFile "input"
type Point = object
  x, y: int
var labels: Table[string, seq[Point]]

# Parse into sparsemap
for y, l in input.splitLines.toseq():
  h = h.max(y+1)
  for x, c in l:
    w = w.max(x+1)
    map.set(x, y, c)

# Find portals
let lo = [[(0,-2),(0,-1)], [(-2,0),(-1,0)], [(0,1),(0,2)], [(1,0),(2,0)]]
for (x, y, c) in map:
  if c == '.':
    for ds in lo:
      var label = "  "
      for i, (dx, dy) in ds:
        label[i] = map.get(x+dx, y+dy)
      if label[0] in {'A'..'Z'} and label[1] in {'A'..'Z'}:
        if label notin labels: labels[label] = newSeq[Point]()
        labels[label].add Point(x: x, y:y)

proc search(pFrom, pTo: Point): int =
  var flood: SparseMap[int]
  var found: int
  proc fill(x, y, l: int) =
    if x == pTo.x and y == pTo.y:
      found = l
      return
    let c = map[y][x]
    if c != '.':
      return
    if c == '.' and flood.get(x, y) == 0 or flood.get(x, y) > l:
      flood.set(x, y, l)
      fill(x, y+1, l+1)
      fill(x-1, y, l+1)
      fill(x+1, y, l+1)
      fill(x, y-1, l+1)
      for label, ps in labels:
        if ps.len == 2:
          for i, p in ps:
            if p.x == x and p.y == y:
              fill(ps[1-i].x, ps[1-i].y, l+1)
  fill(pFrom.x, pFrom.y, 1)
  echo flood
  return found

let pAA = labels["AA"][0]
let pZZ = labels["ZZ"][0]
part1 =  search(pAA, pZZ) - 1

echo "part1: ", part1
