import strutils, sequtils, math, tables, algorithm, deques, options

type
  Program = seq[int]

  Phases = seq[int]

  PowerCalculator = proc(program: Program, phases: Phases): int

  Cpu = ref object
    p: Program
    ip: int
    input: Deque[int]
    output: Deque[int]

  Opcode = enum
    opAdd = 1,
    opMul = 2,
    opIn  = 3,
    opOut = 4,
    opJt  = 5,
    opJf  = 6,
    opLt  = 7,
    opEq  = 8,
    opBye = 99,

let opLen = [ 0, 4, 4, 2, 2, 3, 3, 4, 4 ]

# Some templates for instruction decoding

template op: Opcode = (cpu.p[cpu.ip] mod 100).Opcode
template rImm(off): int = cpu.p[cpu.ip+off]
template rPos(off): int = cpu.p[cpu.p[cpu.ip+off]]

template r(off): int =
  if ((cpu.p[cpu.ip] div 10^(off+1)) mod 10) != 0:
    rImm(off)
  else:
    rPos(off)

# Run the CPU for one tick. Returns true if still running

proc tick(cpu: Cpu): bool =
  case op:
    of opAdd:
      rPos(3) = r(1) + r(2)
    of opMul:
      rPos(3) = r(1) * r(2)
    of opIn:
      if cpu.input.len == 0:
        return true
      rPos(1) = cpu.input.popFirst
    of opOut:
      cpu.output.addLast r(1)
    of opJt:
      if r(1) != 0:
        cpu.ip = r(2)
        return true
    of opJf:
      if r(1) == 0:
        cpu.ip = r(2)
        return true
    of opLt:
      rPos(3) = int(r(1) < r(2))
    of opEq:
      rPos(3) = int(r(1) == r(2))
    of opBye:
      return false
  inc cpu.ip, oplen[op.int]
  return true

proc send(cpu: Cpu, val: Option[int]) =
  if isSome(val):
    cpu.input.addLast(val.get)

proc recv(cpu: Cpu): Option[int] =
  if cpu.output.len > 0:
    result = some cpu.output.popFirst

# Create a new CPU with the given program and an optional number of inputs

proc newCpu(p: Program, inputs: varargs[int]): Cpu =
  result = Cpu(p: p, input: initDeque[int](), output: initDeque[int]())
  for i in inputs:
    result.send some(i)


# Calculate power for part 1: serial operation feeding the output of
# the first progrma into the next

proc calcPower1(program: Program, phases: Phases): int =
  for phase in phases:
    var cpu = newCpu(program, phase, result)
    while cpu.tick:
      discard
    result = cpu.recv.get


# Calculate power for part 2: all CPUs run in parallel while output is sent
# around to the next in the chain

proc calcPower2(program: Program, phases: Phases): int =

  var cpus = phases.mapIt(newCpu(program, it))
  var v = some 0
  var running = cpus.len

  while running > 0:
    running = 0
    for i, cpu in cpus:
      cpu.send v
      if cpu.tick:
        inc running
      v = cpu.recv
      if isSome v:
        result = result.max v.get

# Iterate over all permutations of the given phase

proc calcMaxPower(program: Program, range: Slice[int], fn: PowerCalculator): int =
  var phases = range.toSeq
  while true:
    result = result.max fn(program, phases)
    if not phases.nextPermutation:
      break

let input = readLines("input")[0].split(",").map(parseInt)

echo "part1: ", calcMaxPower(input, 0..4, calcPower1)
echo "part2: ", calcMaxPower(input, 5..9, calcPower2)
