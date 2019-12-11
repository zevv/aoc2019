import strutils, sequtils
import ../lib/intcode

# Run test and BOOST program

let input = readLines("input")[0].split(",").map(parseInt)
 
echo "part1: ", newCpu(input, 1).run()
echo "part2: ", newCpu(input, 2).run()

