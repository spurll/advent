#=
--- Day 22: Wizard Simulator 20XX ---

Little Henry Case decides that defeating bosses with swords and stuff is boring. Now he's
playing the game with a wizard. Of course, he gets stuck on another boss and needs your help
again.

In this version, combat still proceeds with the player and the boss taking alternating
turns. The player still goes first. Now, however, you don't get any equipment; instead, you
must choose one of your spells to cast. The first character at or below 0 hit points loses.

Since you're a wizard, you don't get to wear armor, and you can't attack normally. However,
since you do magic damage, your opponent's armor is ignored, and so the boss effectively has
zero armor as well. As before, if armor (from a spell, in this case) would reduce damage
below 1, it becomes 1 instead - that is, the boss' attacks always deal at least 1 damage.

On each of your turns, you must select one of your spells to cast. If you cannot afford to
cast any spell, you lose. Spells cost mana; you start with 500 mana, but have no maximum
limit. You must have enough mana to cast a spell, and its cost is immediately deducted when
you cast it. Your spells are Magic Missile, Drain, Shield, Poison, and Recharge.

Magic Missile costs 53 mana. It instantly does 4 damage.
Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your
armor is increased by 7.
Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn
while it is active, it deals the boss 3 damage.
Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each
turn while it is active, it gives you 101 new mana.
Effects all work the same way. Effects apply at the start of both the player's turns and the
boss' turns. Effects are created with a timer (the number of turns they last); at the start
of each turn, after they apply any effect they have, their timer is decreased by one. If
this decreases the timer to zero, the effect ends. You cannot cast a spell that would start
an effect which is already active. However, effects can be started on the same turn they
end.

For example, suppose the player has 10 hit points and 250 mana, and that the boss has 13 hit
points and 8 damage:

-- Player turn --
- Player has 10 hit points, 0 armor, 250 mana
- Boss has 13 hit points
Player casts Poison.

-- Boss turn --
- Player has 10 hit points, 0 armor, 77 mana
- Boss has 13 hit points
Poison deals 3 damage; its timer is now 5.
Boss attacks for 8 damage.

-- Player turn --
- Player has 2 hit points, 0 armor, 77 mana
- Boss has 10 hit points
Poison deals 3 damage; its timer is now 4.
Player casts Magic Missile, dealing 4 damage.

-- Boss turn --
- Player has 2 hit points, 0 armor, 24 mana
- Boss has 3 hit points
Poison deals 3 damage. This kills the boss, and the player wins.
Now, suppose the same initial conditions, except that the boss has 14 hit points instead:

-- Player turn --
- Player has 10 hit points, 0 armor, 250 mana
- Boss has 14 hit points
Player casts Recharge.

-- Boss turn --
- Player has 10 hit points, 0 armor, 21 mana
- Boss has 14 hit points
Recharge provides 101 mana; its timer is now 4.
Boss attacks for 8 damage!

-- Player turn --
- Player has 2 hit points, 0 armor, 122 mana
- Boss has 14 hit points
Recharge provides 101 mana; its timer is now 3.
Player casts Shield, increasing armor by 7.

-- Boss turn --
- Player has 2 hit points, 7 armor, 110 mana
- Boss has 14 hit points
Shield's timer is now 5.
Recharge provides 101 mana; its timer is now 2.
Boss attacks for 8 - 7 = 1 damage!

-- Player turn --
- Player has 1 hit point, 7 armor, 211 mana
- Boss has 14 hit points
Shield's timer is now 4.
Recharge provides 101 mana; its timer is now 1.
Player casts Drain, dealing 2 damage, and healing 2 hit points.

-- Boss turn --
- Player has 3 hit points, 7 armor, 239 mana
- Boss has 12 hit points
Shield's timer is now 3.
Recharge provides 101 mana; its timer is now 0.
Recharge wears off.
Boss attacks for 8 - 7 = 1 damage!

-- Player turn --
- Player has 2 hit points, 7 armor, 340 mana
- Boss has 12 hit points
Shield's timer is now 2.
Player casts Poison.

-- Boss turn --
- Player has 2 hit points, 7 armor, 167 mana
- Boss has 12 hit points
Shield's timer is now 1.
Poison deals 3 damage; its timer is now 5.
Boss attacks for 8 - 7 = 1 damage!

-- Player turn --
- Player has 1 hit point, 7 armor, 167 mana
- Boss has 9 hit points
Shield's timer is now 0.
Shield wears off, decreasing armor by 7.
Poison deals 3 damage; its timer is now 4.
Player casts Magic Missile, dealing 4 damage.

-- Boss turn --
- Player has 1 hit point, 0 armor, 114 mana
- Boss has 2 hit points
Poison deals 3 damage. This kills the boss, and the player wins.
You start with 50 hit points and 500 mana points. The boss's actual stats are in your puzzle
input. What is the least amount of mana you can spend and still win the fight? (Do not
include mana recharge effects as "spending" negative mana.)

Your puzzle answer was 900.

The first half of this puzzle is complete! It provides one gold star: *

--- Part Two ---

On the next run through the game, you increase the difficulty to hard.

At the start of each player turn (before any other effects apply), you lose 1 hit point. If
this brings you to or below 0 hit points, you lose.

With the same starting stats for you and the boss, what is the least amount of mana you can
spend and still win the fight?
=#

type Character
    hp::Int
    damage::Int
    armor::Int
    mp::Int
end

type Spell
    name::AbstractString
    cost::Int
    action::Function
end

type Effect
    name::AbstractString
    timer::Int
    action::Function
end

function boss_hit()
    damage = max(1, boss.damage - player.armor)
    println("Boss hits player for $damage damage.")
    (player.hp -= damage) <= 0
end

function player_cast(spell::Spell)
    player.mp -= spell.cost

    (player.mp < 0) && return false

    println("Player casts $(spell.name).")
    spell.action()
    return boss.hp > 0
end

function resolve_effects()
    for effect in effects
        println("Resolving the effect of $(effect.name)...")
        effect.timer -= 1
        effect.action(effect.timer)
    end
    filter!(effect -> effect.timer > 0, effects)
end

function print_stats()
    println("\nPLAYER: $(player.hp) HP, $(player.mp) MP, $(player.armor) armor")
    println("BOSS: $(boss.hp) HP, $(boss.damage) damage\n")

    if boss.hp <= 0
        println("BOSS IS DEAD!\n")
    end
    if (player.hp <= 0) || (player.mp < 0)
        println("PLAYER IS DEAD!\n")
    end
end

function hard_mode()
    println("HARD MODE: Player loses 1 HP.")
    return (player.hp -= 1) <= 0
end

function win(spell_chain)
    for spell in spell_chain
        print_stats()

        hard && hard_mode() && return false

        resolve_effects()

        if player_cast(spell)
            active_effects = [effect.name for effect in effects]
            if length(active_effects) > length(unique(active_effects))
                println("\nMulitple effects of same type active. Invalid spell cast!")
                return false
            end

            resolve_effects()
            if boss_hit()
                print_stats()
                return false
            end
        end

        if player.mp < 0
            print_stats()
            return false
        end
    end

    (boss.hp > 0) && println("\nPlayer out of spells!")

    return boss.hp <= 0
end

# Find all combinations of spells that have the specified combined mana cost.
function select_spells!(chains, spells, mana, current_chain=nothing)
    if is(current_chain, nothing)
        current_chain = Spell[]
    end

    total_cost = sum(Int[spell.cost for spell in current_chain])
    (total_cost == mana) && push!(chains, current_chain)
    (total_cost >= mana) && return

    for spell in spells
        select_spells!(chains, spells, mana, Spell[current_chain; spell])
    end
end

# I am become Death, destroyer of code.
spells = [
    Spell("Magic Missile", 53, () -> boss.hp -= 4),
    Spell("Drain", 73, function ()
        boss.hp -= 2
        player.hp += 2
    end),
    Spell("Shield", 113, function ()
        player.armor += 7
        push!(effects, Effect("Shield", 6, timer -> if timer == 0 player.armor -= 7 end))
    end),
    Spell("Poison", 173, () -> push!(effects, Effect("Poison", 6, timer -> boss.hp -= 3))),
    Spell("Recharge", 229,
        () -> push!(effects, Effect("Recharge", 5, timer -> player.mp += 101))
    )
]

f = open("day_22.txt")
input = readall(f)
close(f)

boss_stats = (
    parse(match(r"Hit Points: (\d+)", input).captures...),
    parse(match(r"Damage: (\d+)", input).captures...),
    0, 0
)

mana = min(map(spell -> spell.cost, spells)...) - 1
hard = true
done = false
effects = []
player = NaN
boss = NaN
while !done
    mana += 1
    chains = []
    select_spells!(chains, spells, mana)
    !isempty(chains) && println("Found $(length(chains)) spell chains that cost $mana...")
    for spell_chain in chains
        effects = []
        println("\n-------------- $(mana) ---------------")
        player, boss = Character(50, 0, 0, 500), Character(boss_stats...)
        (done = win(spell_chain)) && break
    end
end

println("Spent $mana mana to win.")
