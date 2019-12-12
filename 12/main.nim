
import strutils, npeg, math, sequtils

type Moon = ref object
  p, pStart: array[3, int] # Position
  v, vStart: array[3, int] # Velocity

var
  moons: seq[Moon]
  period: array[3, int]
  part1, part2: int

let p = peg lines:
  lines <- *line
  int <- ?'-' * +Digit
  line <- @>int * @>int * @>int:
    let p = [parseInt($1), parseInt($2), parseInt($3)]
    moons.add Moon(p: p, pStart: p)

if p.matchFile("input").ok:

  for n in 1..int.high:

    # Iterate X, Y and Z axis - these are all independent
    for c in 0..2:

      # Update velocity
      for i in 0..<moons.len:
        for j in i+1..<moons.len:
          let d = cmp(moons[i].p[c], moons[j].p[c])
          dec moons[i].v[c], d
          inc moons[j].v[c], d

      # Update position
      for m in moons:
        inc m.p[c], m.v[c]

      # Check if repeated
      if moons.allIt it.p[c] == it.pStart[c] and it.v[c] == it.vStart[c]:
        period[c] = n

    # Calculate energy at step 1000
    if n == 1000:
      part1 = sum moons.mapIt it.p.mapIt(it.abs).foldl(a+b) * 
                              it.v.mapIt(it.abs).foldl(a+b)

    # Calculate part2 and break if all intervals are known
    if period.allIt it != 0:
      part2 = lcm(period)
      break

  echo "part1: ", part1
  echo "part2: ", part2

# vi: ft=nim et ts=2 sw=2

