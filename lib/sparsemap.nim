
import tables

type
  SparseMap*[T] = Table[int, Table[int, T]]

proc set*[T](m: var SparseMap[T], x, y: int, v: T) =
  if y notin m:
    m[y] = initTable[int, T]()
  m[y][x] = v

proc get*[T](m: SparseMap[T], x, y: int): T =
  if y in m and x in m[y]:
    result = m[y][x]

proc `$`*[T](m: SparseMap[T]): string =
  var (xmin, xmax, ymin, ymax) = (int.high, int.low, int.high, int.low)
  for y, l in m:
    (ymin, ymax) = (ymin.min y, ymax.max y)
    for x, v in l:
      (xmin, xmax) = (xmin.min x, xmax.max x)
  for y in ymin..ymax:
    for x in xmin..xmax:
      result.add if m.get(x, y) != T.default: "#" else: " "
    result.add "\n"

proc count*[T](m: SparseMap[T]): int =
  for y, l in m:
    for x, v in l:
      inc result


