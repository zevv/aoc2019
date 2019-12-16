
### Day 1: The Tyranny of the Rocket Equation

What to say? Just do the math and recurse until done.

### Day 2: 1202 Program Alarm

What would AoC be without the obligatory elven CPU? Basic VM dispatcher
with some helper templates for instruction decoding.

### Day 3: Crossed Wires

Ha, found a use for NPeg! Trace the first wire, store all points with the
distance traveled in a sparse 2D map and check for collisions while tracing the
second wire.

### Day 4: Secure Container

Iterate over the range and split the numbers in to base 10 digits. Not
particularly fast but does the job.

### Day 5: Sunny with a Chance of Asteroids

Extension of day 2 with some extra instructions, variable length instructions
and addressing modes. I have the feeling this will not be the last we see of
this...

### Day 6: Universal Orbit Map

Today I learned about the `-+-` HashSet operator!

### Day 7: Amplification Circuit

Aaaand, there's the CPU again. Needs some refactoring when you need to run them
in parallel, though.

### Day 8: Space Image Format

Nim functional programming show off.

### Day 9: Sensor Boost

_You now have a complete Intcode computer_. About time, let's move it into a library.

### Day 10: Monitoring Station

I got away with assuming target #200 will be hit in the first round, ha!

### Day 11: Space Police

Day 3 + Day 9 = Day 11. 

### Day 12: The N-Body Problem

is actually a N-dimensional problem. Fun, but I cheated and took a hint from someone.

### Day 13: Care Package

Pong.

### Day 14: Space Stoichiometry

This was fun. Part1 is pretty trivial make-stuff-and-recursively-make-more-stuff,
part2 does a quick manufacturing of large batches until we run out of ore and
then extrapolates the last bit, which turns out to be faster then doing a
binary search for the biggest possible fit.

### Day 15: Oxygen System

Today is sunday:

- Sleep late
- Map the maze with a brute force random walk and count the distance by hand
- Have breakfast
- Have a hike in the woods
- Have a coffee!
- Properly recurse for part 1 and flood fill for part 2

### Day 16: Flawed Frequency Transmission

Part 2 took me way too long to figure out - which was of course the point of
the whole excersise. After spending too much time trying to optimize the FFT
I suspected the trick was to find the shortcut, which popped up after staring
at the example run for some time. Sneaky!
