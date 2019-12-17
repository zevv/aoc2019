import math, tables, strutils, options, sequtils, os, npeg
import ../lib/intcode
import ../lib/sparsemap

var
  input = readLines("input")[0].split(",").map(parseInt)
  cpu = newCpu(input)
  map: SparseMap[char]
  dir, pdir, cx, cy: int
  part1, part2: int
  path: string
  program: string

# Read camera output into sparse map and count crossings
var x, y: int
while true:
  let s = cpu.runRecv().char
  case s
    of '\0': break
    of '\n': (x, y) = (0, y+1)
    of '^': (cx, cy, x) = (x, y, x+1)
    else:
      map.set(x, y, s)
      if map.slice(x-2, y-2, x, y).concat().join() == ".#.###.#.":
        part1 += (x-1)*(y-1)
      inc x

# Trace the path
template xnext(): int = cx + [0, 1, 0, -1][dir mod 4]
template ynext(): int = cy + [-1, 0, 1, 0][dir mod 4]

var steps: seq[string]
while true:
  # Rotate if we can't go straight ahead
  if map.get(xnext, ynext) != '#': dir = dir + 1
  if map.get(xnext, ynext) != '#': dir = dir + 2
  if map.get(xnext, ynext) != '#': break

  # Step until we reach the end of this line
  var len = 0
  while map.get(xnext, ynext) == '#':
    (cx, cy, len) = (xnext, ynext, len+1)

  # Record rotation and length in program
  steps.add if dir-pdir == 1: "R" else: "L"
  steps.add $len
  pdir = dir

path = steps.join(",")

let s = path

# Find common substrings between length 5 and 20
var part: Table[string, bool]
for len in countdown(20, 5):
  for o1 in 0..(s.len-len):
    for o2 in (o1+1)..(s.len-len):
      if s[o1..(o1+len-1)] == s[o2..(o2+len-1)]:
        if isAlphaAscii(s[o1]) and isDigit(s[o1+len-1]) and s[o1+len] == ',':
          part[s[o1..(o1+len-1)]] = true

# Try all permutations of found substrings
block hop:
  proc check(ps: varargs[string]): string =
    # Check if the three given substrings can build the pattern
    var o = 0
    var ss: seq[char]
    while o < s.len:
      var match: bool
      for i, p in ps:
        if s[o..(o+p.high)] == p:
          o += p.len + 1
          ss.add (i + 'A'.int).char
          match = true
          break
      if not match:
        return
    return ss.join(",") & "\n" & ps.join("\n") & "\nN\n"

  for p1, _ in part:
    for p2, _ in part:
      for p3, _ in part:
        program = check(p1, p2, p3)
        if program != "":
          break hop

# Run the intcode program on a fresh CPU to get part 2
input = readLines("input")[0].split(",").map(parseInt)
input[0] = 2
cpu = newCpu(input)
for c in program:
  cpu.send some c.int

while true:
  let s = cpu.runRecv()
  if s > 255:
    part2 = s
    break

echo "part1: ", part1
echo "part2: ", part2
