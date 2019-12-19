
import strutils, sequtils 
import ../lib/intcode

let input = readLines("input")[0].split(",").map(parseInt)
var part1, part2: int

proc probe(x, y: int): int = newCpu(input, x, y).runRecv()

# part1: count
for y in 0..49:
  for x in 0..49:
    inc part1, probe(x, y)

# part2: trace one beam edge and check for fit
var (x, y) = (0, 100)
while probe(x+99, y-99) == 0:
  inc y
  while probe(x, y) == 0:
    inc x

part2 = x*10000 + (y-99)

echo "part1: ", part1
echo "part2: ", part2
