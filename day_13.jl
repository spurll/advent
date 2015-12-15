#=
--- Day 13: Knights of the Dinner Table ---

In years past, the holiday feast with your family hasn't gone so well. Not everyone gets
along! This year, you resolve, will be different. You're going to find the optimal seating
arrangement and avoid all those awkward conversations.

You start by writing up a list of everyone invited and the amount their happiness would
increase or decrease if they were to find themselves sitting next to each other person.
You have a circular table that will be just big enough to fit everyone comfortably, and so
each person will have exactly two neighbors.

For example, suppose you have only four attendees planned, and you calculate their potential
happiness as follows:

Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol.
Then, if you seat Alice next to David, Alice would lose 2 happiness units (because David
talks so much), but David would gain 46 happiness units (because Alice is such a good
listener), for a total change of 44.

If you continue around the table, you could then seat Bob next to Alice (Bob gains 83, Alice
gains 54). Finally, seat Carol, who sits next to Bob (Carol gains 60, Bob loses 7) and David
(Carol gains 55, David gains 41). The arrangement looks like this:

     +41 +46
+55   David    -2
Carol       Alice
+60    Bob    +54
     -7  +83
After trying every other seating arrangement in this hypothetical scenario, you find that
this one is the most optimal, with a total change in happiness of 330.

What is the total change in happiness for the optimal seating arrangement of the actual
guest list?

Your puzzle answer was 733.

The first half of this puzzle is complete! It provides one gold star: *

--- Part Two ---

In all the commotion, you realize that you forgot to seat yourself. At this point, you're
pretty apathetic toward the whole thing, and your happiness wouldn't really go up or down
regardless of who you sit next to. You assume everyone else would be just as ambivalent
about sitting next to you, too.

So, add yourself to the list, and give all happiness relationships that involve you a score
of 0.

What is the total change in happiness for the optimal seating arrangement that actually
includes yourself?
=#

type Node
    name::AbstractString
    edges::Vector
end

type Edge
    nodes::Vector
    distance::Number
end

function happiness(a::Node, b::Node)
    delta = 0
    for edge in a.edges
        if (b === edge.nodes[1]) || (b === edge.nodes[2])
            delta += edge.distance
        end
    end
    return delta
end

nodes = Dict{AbstractString, Node}()

f = open("day_13.txt")
for line in eachline(f)
    name_1, gain_loss, delta, name_2 = match(
        r"(\w+) would (\w+) (\d+) happiness units by sitting next to (\w+).", line
    ).captures

    if haskey(nodes, name_1)
        person_1 = nodes[name_1]
    else
        person_1 = Node(name_1, Vector{Edge}())
        nodes[name_1] = person_1
    end

    if haskey(nodes, name_2)
        person_2 = nodes[name_2]
    else
        person_2 = Node(name_2, Vector{Edge}())
        nodes[name_2] = person_2
    end

    edge = Edge([person_1, person_2], (gain_loss == "gain") ? parse(delta) : -parse(delta))
    push!(nodes[name_1].edges, edge)
    push!(nodes[name_2].edges, edge)
end
close(f)

function find_best(people)
    happiest, seating = -Inf, ""

    for plan in permutations(people)
        current_happiness = 0
        current_seat = plan[1]

        for next_seat in [plan[2:end]; plan[1]]
            current_happiness += happiness(current_seat, next_seat)
            current_seat = next_seat
        end

        if current_happiness > happiest
            happiest = current_happiness
            seating = join([n.name for n in plan], " -> ")
        end
    end

    return happiest, seating
end

happiest, seating = find_best(collect(values(nodes)))
println("$happiest: $seating")

nodes["Gem"] = Node("Gem", Vector{Edge}())

happiest, seating = find_best(collect(values(nodes)))
println("$happiest: $seating")
