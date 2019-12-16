
import sequtils, strutils

# Part 1: Crunch away
  
proc fft(runs: int, sig: seq[int]): seq[int] =
  const sintab = [ 0, 1, 0, -1 ]
  result = sig
  for phase in 1..runs:
    var os: seq[int]
    for f in 1..result.len:
      var acc = 0
      for i, v in result:
        let idx = ((i+1) div f) mod 4
        acc += sintab[idx] * v
      os.add abs(acc) mod 10
    result = os

let input = readFile("input").strip()
let sig1 = input.mapIt(it.int - '0'.int)
let part1 = fft(100, sig1).join()[0..7]

# Part 2: do the smart thing

proc round(input: seq[int]): seq[int] =
  var output = newSeq[int](input.len)
  var v = 0
  for i in countdown(input.high, input.high div 2):
    v += input[i]
    output[i] = v
  result = output.mapIt(it mod 10)

var sig2 = input.repeat(10000).mapIt(it.int - '0'.int)
for i in 1..100: sig2 = round(sig2)
let offset = input[0..6].parseInt()
let part2 = sig2[offset..offset+7].join()

echo "part1: ", part1
echo "part2: ", part2
