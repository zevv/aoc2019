import strutils, sequtils, math
import ../aoc

let input = intLines("input")
  
proc fuel1(f: int): int = f div 3 - 2
  
proc fuel2(f: int): int =
  result = fuel1(f)
  if result > 0:
    result += fuel2(result)

echo "part1: ", input.map(fuel1).sum()
echo "part2: ", input.map(fuel2).sum()

# vi: ft=nim et ts=2 sw=2

