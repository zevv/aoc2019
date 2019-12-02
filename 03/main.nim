import strutils, npeg, tables

type
  Map[T] = Table[int, Table[int, T]]

proc set[T](m: var Map[T], x, y: int, v: T) =
  if y notin m:
    m[y] = initTable[int, T]()
  m[y][x] = v

proc get[T](m: Map[T], x, y: int): T =
  if y in m and x in m[y]:
    result = m[y][x]

var
  map: Map[int]
  nmin = int.high
  dmin = int.high
  x, y, n, st = 0

let p1 = peg "input":
  input <- route * nl * route
  route <- dir * *("," * dir)

  nl <- '\n':
    (x, y, n, st) = (0, 0, 0, 1)

  dir <- >1 * >+Digit:
    for i in 1..parseInt($2):
      case $1
        of "R": inc x
        of "L": dec x
        of "U": inc y
        of "D": dec y
      inc n
      if st == 0:
        map.set(x, y, n)
      else:
        if map.get(x, y) != 0:
          let ntot = n + map.get(x, y)
          let d = abs(x)+abs(y)
          dmin = min(dmin, d)
          nmin = min(nmin, ntot)

if p1.matchFile("input").ok:
  echo "part1: ", dmin
  echo "part2: ", nmin
