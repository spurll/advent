"""
--- Day 7: Some Assembly Required ---

This year, Santa brought little Bobby Tables a set of wires and bitwise logic gates! Unfortunately, little Bobby is a little under the recommended age range, and he needs help assembling the circuit.

Each wire has an identifier (some lowercase letters) and can carry a 16-bit signal (a number from 0 to 65535). A signal is provided to each wire by a gate, another wire, or some specific value. Each wire can only get a signal from one source, but can provide its signal to multiple destinations. A gate provides no signal until all of its inputs have a signal.

The included instructions booklet describes how to connect the parts together: x AND y -> z means to connect wires x and y to an AND gate, and then connect its output to wire z.

For example:

123 -> x means that the signal 123 is provided to wire x.
x AND y -> z means that the bitwise AND of wire x and wire y is provided to wire z.
p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and then provided to wire q.
NOT e -> f means that the bitwise complement of the value from wire e is provided to wire f.
Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If, for some reason, you'd like to emulate the circuit instead, almost all programming languages (for example, C, JavaScript, or Python) provide operators for these gates.

For example, here is a simple circuit:

123 -> x
456 -> y
x AND y -> d
x OR y -> e
x LSHIFT 2 -> f
y RSHIFT 2 -> g
NOT x -> h
NOT y -> i
After it is run, these are the signals on the wires:

d: 72
e: 507
f: 492
g: 114
h: 65412
i: 65079
x: 123
y: 456
In little Bobby's kit's instructions booklet (provided as your puzzle input), what signal is ultimately provided to wire a?

Your puzzle answer was 3176.

The first half of this puzzle is complete! It provides one gold star: *

--- Part Two ---

Now, take the signal you got on wire a, override wire b to that signal, and reset the other wires (including wire a). What new signal is ultimately provided to wire a?
"""

map = Dict([("AND", "&"), ("OR", "|"), ("LSHIFT", "<<"), ("RSHIFT", ">>>"), ("NOT", "~")])

function read_instructions(file, b=nothing)
    instructions = []

    f = open(file)
    for line in eachline(f)
        input_1, operator, input_2, output = match(r"([\da-z]+)? ?([A-Z]+)? ?([\da-z]+)? -> ([a-z]+)", line).captures

        if is(input_1, nothing)
            input_1 = ""
        elseif !is(match(r"\D+", input_1), nothing)
            input_1 = "results[\"$input_1\"]"
        end

        if is(operator, nothing)
            operator = ""
        else
            operator = map[operator]
        end

        if is(input_2, nothing)
            input_2 = ""
        elseif !is(match(r"\D+", input_2), nothing)
            input_2 = "results[\"$input_2\"]"
        end

        if (output == "b") && !is(b, nothing)
            println("REPLACING B WITH $b")
            input_1, operator, input_2 = b, "", ""
        end

        instruction = "results[\"$output\"] = $input_1 $operator $input_2"
        push!(instructions, instruction)
    end
    close(f)

    return instructions
end

instructions = read_instructions("day_7.txt")
results = Dict()

while !isempty(instructions)
    current = shift!(instructions)
    try
        eval(parse(current))
        println(current)
    catch e
        #println("DOES NOT COMPUTE: $current")
        push!(instructions, current)
    end
end

old_results = results
results = Dict()
instructions = read_instructions("day_7.txt", old_results["a"])

while !isempty(instructions)
    current = shift!(instructions)
    try
        eval(parse(current))
        println(current)
    catch e
        #println("DOES NOT COMPUTE: $current")
        push!(instructions, current)
    end
end

println(old_results["a"])
println(results["a"])
