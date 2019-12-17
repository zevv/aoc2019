import math, tables, deques, options

type
  
  Program = seq[int]

  Mode = enum Pos = 0, Imm = 1, Rel = 2

  Cpu* = ref object
    p: Program
    ip: int
    base: int
    input: Deque[int]
    output: Deque[int]
    wantsRead*: bool

  Opcode = enum
    opAdd  = 1,
    opMul  = 2,
    opIn   = 3,
    opOut  = 4,
    opJt   = 5,
    opJf   = 6,
    opLt   = 7,
    opEq   = 8,
    opBase = 9,
    opBye  = 99,

const
  opLen = [ 0, 4, 4, 2, 2, 3, 3, 4, 4, 2 ]

# Some templates for instruction decoding

template op: Opcode = (cpu.p[cpu.ip] mod 100).Opcode

template r(off): int =
  let mode = ((cpu.p[cpu.ip] div 10^(off+1)) mod 10).Mode
  let a = case mode
    of Imm: cpu.ip+off
    of Pos: cpu.p[cpu.ip+off]
    of Rel: cpu.p[cpu.ip+off]+cpu.base
  cpu.p.setLen max(cpu.p.len, a+1)
  cpu.p[a]

# Run the CPU for one tick. Returns true if still running

proc tick*(cpu: Cpu): bool =
  case op:
    of opAdd:
      r(3) = r(1) + r(2)
    of opMul:
      r(3) = r(1) * r(2)
    of opIn:
      if cpu.input.len == 0:
        cpu.wantsRead = true
        return true
      r(1) = cpu.input.popFirst
      cpu.wantsRead = false
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
      r(3) = int(r(1) < r(2))
    of opEq:
      r(3) = int(r(1) == r(2))
    of opBye:
      return false
    of opBase:
      inc cpu.base, r(1)
  inc cpu.ip, oplen[op.int]
  return true

proc send*(cpu: Cpu, val: Option[int]) =
  if isSome(val):
    cpu.input.addLast(val.get)

proc recv*(cpu: Cpu): Option[int] =
  if cpu.output.len > 0:
    result = some cpu.output.popFirst

proc runRecv*(cpu: Cpu): int =
  while cpu.tick():
    let v = cpu.recv()
    if isSome(v):
      return v.get()

proc run*(cpu: Cpu): int =
  while cpu.tick(): discard
  cpu.recv.get()

# Create a new CPU with the given program and an optional number of inputs

proc newCpu*(p: Program, inputs: varargs[int]): Cpu =
  result = Cpu(p: p, input: initDeque[int](), output: initDeque[int]())
  for i in inputs:
    result.send some(i)

proc copy*(cpu: Cpu): Cpu =
  result = newCpu(cpu.p)
  result.ip = cpu.ip

