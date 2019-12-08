import sequtils, strutils, sugar

let
  # Read input and split into layers
  (w, h) = (25, 6)
  input = readFile("input").strip
  layerCount = input.len div (w*h)
  layers = input.toSeq.distribute(layerCount)

  # Do part1: check for corruption
  zeroCounts = layers.mapIt(it.count('0'))
  checkLayer = layers[zeroCounts.find(zeroCounts.min)]
  part1 = checkLayer.count('1') * checkLayer.count('2')

  # Do part2: layer stacking
  part2 = "\n" & (0..<w*h).
                 mapIt(layers.filter(l => l[it] != '2')[0][it]).
                 distribute(h).mapIt(it.join).join("\n")

echo "part1: ", part1
echo "part2: ", part2

