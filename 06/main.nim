
import npeg, tables, sets

type Obj = ref object
  orbits: string
  path: HashSet[string]

var
  objs: Table[string, Obj]
  checksum: int

let p = peg os:
  os <- +o
  o <- >+Alnum * ")" * >+Alnum * "\n":
    objs[$2] = Obj(orbits: $1)

if p.matchFile("input").ok:
  for id, obj in objs:
    var id2 = id
    while id2 in objs:
      id2 = objs[id2].orbits
      obj.path.incl id2
      inc checksum

  echo "part1: ", checksum
  echo "part2: ", card(objs["YOU"].path -+- objs["SAN"].path)
