
import strutils, math, sequtils, algorithm, sugar, tables

type
  Point = ref object
    x, y: float
    a, d: float

var
  ps: seq[Point]

let input = readFile("input").split("\n")
for y, l in input:
  for x, c in l:
    if c == '#':
      ps.add Point(x:x.float, y:y.float)

proc angle(p1, p2: Point): float = 
  result = arctan2(p2.y-p1.y, p2.x-p1.x) + Pi*0.5
  if result < 0: result += Pi*2

proc dist(p1, p2: Point): float =
  hypot(p2.y-p1.y, p2.x-p1.x)

# Part1: find asteroid with the best view

let cs = ps.map(p => ps.mapIt(p.angle(it)).deduplicate().len)
let part1 = cs.max()
let base = ps[cs.find(part1)]

# Part2: Kill em all. I got away with assuming target #200 will be hit in the
# first round, ha!

var targets: Table[float, Point]
var angles: seq[float]

for p in ps:
  p.a = base.angle p
  p.d = base.dist p
  if p.a notin targets or p.d < targets[p.a].d:
    targets[p.a] = p
    angles.add p.a

angles = angles.deduplicate()
sort angles
var part2 = 0

let a = angles[199]
part2 = targets[a].x.int + targets[a].y.int * 100

echo "part1: ", part1
echo "part2: ", part2

doAssert part1 == 247
doAssert part2 == 1919

