import strutils, sequtils, math

let input = 128392..643281

proc test(pIn: int, maxRunLen: int): bool =
  var (runLen, p) = (0, pIn)
  for i in 0..5:
    let (v0, v1) = (p mod 10, p div 10 mod 10)
    if v1 > v0:
      return false
    elif v1 == v0:
      inc runLen
    else:
      if runLen in 1..<maxRunLen:
        result = true
      runLen = 0
    p = p div 10
  if runLen in 1..<maxRunLen:
    result = true

proc part(m: int): int =
  for i in input:
    if test(i, m):
      inc result

echo "part1: ", part(6)
echo "part2: ", part(2)

# vi: ft=nim et ts=2 sw=2

