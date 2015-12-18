#=
--- Day 18: Like a GIF For Your Yard ---

After the million lights incident, the fire code has gotten stricter: now, at most ten
thousand lights are allowed. You arrange them in a 100x100 grid.

Never one to let you down, Santa again mails you instructions on the ideal lighting
configuration. With so few lights, he says, you'll have to resort to animation.

Start by setting your lights to the included initial configuration (your puzzle input). A #
means "on", and a . means "off".

Then, animate your grid in steps, where each step decides the next configuration based on
the current one. Each light's next state (either on or off) depends on its current state and
the current states of the eight lights adjacent to it (including diagonals). Lights on the
edge of the grid might have fewer than eight neighbors; the missing ones always count as
"off".

For example, in a simplified 6x6 grid, the light marked A has the neighbors numbered 1
through 8, and the light marked B, which is on an edge, only has the neighbors marked 1
through 5:

1B5...
234...
......
..123.
..8A4.
..765.
The state a light should have next is based on its current state (on or off) plus the number
of neighbors that are on:

A light which is on stays on when 2 or 3 neighbors are on, and turns off otherwise.
A light which is off turns on if exactly 3 neighbors are on, and stays off otherwise.
All of the lights update simultaneously; they all consider the same current state before
moving to the next.

Here's a few steps from an example configuration of another 6x6 grid:

Initial state:
.#.#.#
...##.
#....#
..#...
#.#..#
####..

After 1 step:
..##..
..##.#
...##.
......
#.....
#.##..

After 2 steps:
..###.
......
..###.
......
.#....
.#....

After 3 steps:
...#..
......
...#..
..##..
......
......

After 4 steps:
......
......
..##..
..##..
......
......
After 4 steps, this example has four lights on.

In your grid of 100x100 lights, given your initial configuration, how many lights are on
after 100 steps?

Your puzzle answer was 821.

The first half of this puzzle is complete! It provides one gold star: *

--- Part Two ---

You flip the instructions over; Santa goes on to point out that this is all just an
implementation of Conway's Game of Life. At least, it was, until you notice that something's
wrong with the grid of lights you bought: four lights, one in each corner, are stuck on and
can't be turned off. The example above will actually run like this:

Initial state:
##.#.#
...##.
#....#
..#...
#.#..#
####.#

After 1 step:
#.##.#
####.#
...##.
......
#...#.
#.####

After 2 steps:
#..#.#
#....#
.#.##.
...##.
.#..##
##.###

After 3 steps:
#...##
####.#
..##.#
......
##....
####.#

After 4 steps:
#.####
#....#
...#..
.##...
#.....
#.#..#

After 5 steps:
##.###
.##..#
.##...
.##...
#.#...
##...#
After 5 steps, this example now has 17 lights on.

In your grid of 100x100 lights, given your initial configuration, but with the four corners
always in the on state, how many lights are on after 100 steps?
=#

grid = Array{Bool}(100, 100)

f = open("day_18.txt")
for (i, line) in enumerate(eachline(f))
    grid[i, :] = collect(rstrip(line)) .== '#'
end
close(f)

function step!(g)
    p = falses(102, 102)
    p[2:101, 2:101] = copy(g)
    for i in 1:100
        for j in 1:100
            g[i, j] = state(g[i, j], p[i:i + 2, j:j + 2])
        end
    end
end

function state(light, neighbourhood)
    return light ? 3 <= sum(neighbourhood) <= 4 : sum(neighbourhood) == 3
end

stuck = [true falses(1, 98) true; falses(98, 100); true falses(1, 98) true]
grid_2 = copy(grid) | stuck

for i in 1:100
    step!(grid)
    step!(grid_2)
    grid_2 |= stuck
end

println(sum(grid))
println(sum(grid_2))
