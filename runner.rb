require './population'
require './tournament'
require './individual'
require './matchup'

TOURNAMENT_SIZE = 8
POPULATION_SIZE = 100
REPLACEMENT_PERCENTAGE = 0.16
GENERATIONS = 200
CHAMPION_TOURNAMENT_SIZE = 64

def select_parent(population)
  tournament_players = population.random_subset(TOURNAMENT_SIZE)
  tournament = Tournament.new(tournament_players)
  tournament.winner
end

def crossover(parent1, parent2)
  crossover_point = (rand * 97).ceil + 1

  child1_genes = parent2.genes[0...crossover_point]
  child1_genes += parent1.genes[crossover_point..]

  child2_genes = parent1.genes[0...crossover_point]
  child2_genes += parent2.genes[crossover_point..]

  [Individual.new(child1_genes), Individual.new(child2_genes)]
end

def find_champion
  population = Population.new(POPULATION_SIZE)
  print "Fitness score..."

  GENERATIONS.times do
    print "#{ population.fitness_score }..."
    next_generation = []

    (REPLACEMENT_PERCENTAGE * population.size).ceil.times do
      parent1 = select_parent(population)
      parent2 = select_parent(population)

      child1, child2 = crossover(parent1, parent2)
      child1, child2 = crossover(child1, child2)

      child1 = child1.mutate
      child2 = child2.mutate

      next_generation += [child1, child2]
    end

    next_generation = population.strongest(population.size - next_generation.size) + next_generation

    population = Population.new(POPULATION_SIZE, next_generation)
  end

  puts "#{ population.fitness_score }"

  contenders = population.strongest(64)

  tournament = Tournament.new(contenders)
  champion = tournament.winner

  puts "Best individual:"
  puts champion

  champion
end

champions = []
CHAMPION_TOURNAMENT_SIZE.times do
  champions.push(find_champion)
end
tournament = Tournament.new(champions)
overall_champion = tournament.winner

puts "-------------"
puts "Best overall:"
puts "-------------"
puts overall_champion
