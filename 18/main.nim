
import math, tables, strutils, options, sequtils, os, npeg, algorithm, times
import ../lib/intcode
import ../lib/sparsemap

when true:
  let input = readFile "input"

else:
  let input = """
########################
#...............b.C.D.f#
#.######################
#.....@.a.B.c.d.A.e.F.g#
########################
"""

type
  Dist = object
    c: char
    dist: int

  State = object
    map: seq[seq[char]]
    cx, cy: int
    locks: Table[char, (int, int)]
    keys: Table[char, (int, int)]
    path: string

var
  w, h: int
  part1 = int.high
  t1 = cpuTime()
  n = 0

proc readMap(input: string): State =
  var map: SparseMap[char]
  for y, l in input.splitlines().toSeq():
    h = h.max (y+1)
    for x, c in l:
      w = w.max (x+1)
      if c in {'A'..'Z'}: result.locks[c] = (x, y)
      if c in {'a'..'z'}: result.keys[c] = (x, y)
      if c == '@':
        (result.cx, result.cy) = (x, y)
        map.set(x, y, '.')
      else:
        map.set(x, y, c)
    result.map = map.slice(0, 0, w, h)

proc searchKeys(state: var State, x, y: int): seq[Dist] =
  var flood = newSeq[int](w*h)
  var found: seq[Dist]
  var n = 0
  proc fill(state: var State, x, y, l: int) =
    let c = state.map[y][x]
    if c == '#':
      return
    let o = y*w + x
    if c in {'a'..'z'}:
      found.add Dist(c:c, dist:l-1)
    if c == '.' and flood[o] == 0:
      flood[o] = l
      state.fill(x-1, y, l+1)
      state.fill(x+1, y, l+1)
      state.fill(x, y-1, l+1)
      state.fill(x, y+1, l+1)
  state.fill(x, y, 1)
  result = found

proc next(state: var State, len = 0) =
  var keys = state.searchKeys(state.cx, state.cy)

  for key in keys:
    var state2 = state
    state2.path.add key.c

    let (kx, ky) = state2.keys[key.c]
    state2.map[ky][kx] = '.'
    state2.keys.del(key.c)
    (state2.cx, state2.cy) = (kx, ky)

    if key.c.toUpperAscii in state2.locks:
      let (lx, ly) = state2.locks[key.c.toUpperAscii]
      state2.map[ly][lx] = '.'
      state2.locks.del(key.c.toUpperAscii)

    next(state2, len + key.dist)

  if keys.len == 0:
    part1 = part1.min(len )
    let t2 = cpuTime()
    inc n
    echo "done ", len , " ", state.path, " ", part1, " ", n.float / (t2-t1)

var state = readMap(input)
next(state)

echo "part1: ", part1

# < 3642
