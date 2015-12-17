#=
--- Day 17: No Such Thing as Too Much ---

The elves bought too much eggnog again - 150 liters this time. To fit it all into your
refrigerator, you'll need to move it into smaller containers. You take an inventory of the
capacities of the available containers.

For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters. If you need to
store 25 liters, there are four ways to do it:

15 and 10
20 and 5 (the first 5)
20 and 5 (the second 5)
15, 5, and 5
Filling all containers entirely, how many different combinations of containers can exactly
fit all 150 liters of eggnog?

Your puzzle answer was 4372.

--- Part Two ---

While playing with all the containers in the kitchen, another load of eggnog arrives! The
shipping and receiving department is requesting as many containers as you can spare.

Find the minimum number of containers that can exactly fit all 150 liters of eggnog. How
many different ways can you fill that number of containers and still hold exactly 150
litres?

In the example above, the minimum number of containers was two. There were three ways to use
that many containers, and so the answer there would be 3.
=#

total = 150

f = open("day_17.txt")
containers = Int[parse(line) for line in readlines(f)]
close(f)

# Don't actually use p_splits, but I kind of like it.
p_splits(list) = [(item, list[[1:i - 1; i + 1:end]]) for (i, item) in enumerate(list)]
c_splits(list) = [(item, list[i + 1:end]) for (i, item) in enumerate(list)]

# I am a monster.
function count_combinations(target, available)
    sum(available .== target) + sum(Int[
        count_combinations(target - i, remainder)
        for (i, remainder) in c_splits(filter(x -> x < target, available))
    ])
end

# Don't actually keep track of what combintations we've seen, because that's too easy.
function combinations_with_depth(target, available, depth=1)
    combos = sum(available .== target)
    (combos > 0) && return combos, depth

    shallowest, combos = Inf, 0
    for (i, remainder) in c_splits(filter(x -> x < target, available))
        current, best_depth = combinations_with_depth(target - i, remainder, depth + 1)
        if best_depth == shallowest
            combos += current
        elseif (current > 0) && (best_depth < shallowest)
            combos, shallowest = current, best_depth
        end
    end
    return combos, shallowest
end

println(count_combinations(total, containers))
println(combinations_with_depth(total, containers))
