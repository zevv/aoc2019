
import strutils

proc intLines*(fname: string): seq[int] =
  for l in lines("input"):
    result.add l.parseInt

# vi: ft=nim et ts=2 sw=2


