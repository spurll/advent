#=
--- Day 9: All in a Single Night ---

Every year, Santa manages to deliver all of his presents in a single night.

This year, however, he has some new locations to visit; his elves have provided him the
distances between every pair of locations. He can start and end at any two (different)
locations he wants, but he must visit each location exactly once. What is the shortest
distance he can travel to achieve this?

For example, given the following distances:

London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141
The possible routes are therefore:

Dublin -> London -> Belfast = 982
London -> Dublin -> Belfast = 605
London -> Belfast -> Dublin = 659
Dublin -> Belfast -> London = 659
Belfast -> Dublin -> London = 605
Belfast -> London -> Dublin = 982
The shortest of these is London -> Dublin -> Belfast = 605, and so the answer is 605 in this
example.

What is the distance of the shortest route?

Your puzzle answer was 117.

--- Part Two ---

The next year, just to show off, Santa decides to take the route with the longest distance
instead.

He can still start and end at any two (different) locations he wants, and he still must
visit each location exactly once.

For example, given the distances above, the longest route would be 982 via (for example)
Dublin -> London -> Belfast.

What is the distance of the longest route?
=#

type Node
    name::AbstractString
    edges::Vector
end

type Edge
    nodes::Vector
    distance::Number
end

function distance(a::Node, b::Node)
    for edge in a.edges
        if (b === edge.nodes[1]) || (b === edge.nodes[2])
            return edge.distance
        end
    end
end

nodes = Dict{AbstractString, Node}()

f = open("day_9.txt")
for line in eachline(f)
    name_1, name_2, dist = match(r"(\w+) to (\w+) = (\d+)", line).captures

    if haskey(nodes, name_1)
        city_1 = nodes[name_1]
    else
        city_1 = Node(name_1, Vector{Edge}())
        nodes[name_1] = city_1
    end

    if haskey(nodes, name_2)
        city_2 = nodes[name_2]
    else
        city_2 = Node(name_2, Vector{Edge}())
        nodes[name_2] = city_2
    end

    edge = Edge([city_1, city_2], parse(dist))
    push!(nodes[name_1].edges, edge)
    push!(nodes[name_2].edges, edge)
end
close(f)

best_time, best_trip = Inf, ""
worst_time, worst_trip = -Inf, ""

for trip in permutations(collect(values(nodes)))
    current_time = 0
    current_stop = trip[1]

    for next_stop in trip[2:end]
        current_time += distance(current_stop, next_stop)
        current_stop = next_stop
    end

    if current_time < best_time
        best_time = current_time
        best_trip = join([n.name for n in trip], " -> ")
    end

    if current_time > worst_time
        worst_time = current_time
        worst_trip = join([n.name for n in trip], " -> ")
    end
end

println("$best_time: $best_trip")
println("$worst_time: $worst_trip")
