
import math, tables, strutils, npeg

const mined = 1_000_000_000_000.int

type
  Factory = ref object
    chemical: Table[string, Chemical]

  Chemical = ref object
    stock, made, batchSize: int
    ingredients: Table[string, int]

var
  ins: Table[string, int]
  f = Factory()

let p = peg(rules, f: Factory):
  s <- *(Space | ',')
  pair <- s * >+Digit * s * >+Alpha * s
  rules <- +rule
  ingredient <- pair:
    ins[$2] = parseInt($1)
  rule <- +ingredient * "=>" * pair:
    f.chemical[$2] = Chemical(batchSize: parseInt($1), ingredients: ins)
    ins.clear

proc make(f: Factory, what: string, need: int): bool =
  let c = f.chemical[what]
  if need > c.stock:
    if what == "ORE": return true
    let batches = (need - c.stock + c.batchSize - 1) div c.batchSize
    for e, n in c.ingredients:
      result = result or f.make(e, n * batches)
    inc c.stock, c.batchSize * batches
    inc c.made, c.batchSize * batches
  dec c.stock, need

if p.matchFile("input", f).ok:
  f.chemical["ORE"] = Chemical(stock: mined)
  discard f.make("FUEL", 1)
  var part1 = mined - f.chemical["ORE"].stock
  var part2 = 0

  while not f.make("FUEL", 100000):
    let n = f.chemical["FUEL"].made
    let f = 1.0 - (f.chemical["ORE"].stock / mined)
    part2 = (n.float / f).int

  echo "part1: ", part1
  echo "part2: ", part2
