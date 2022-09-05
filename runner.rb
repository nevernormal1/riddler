require './population'
require './tournament'
require './individual'
require './matchup'

TOURNAMENT_SIZE = 8
POPULATION_SIZE = 100
MUTATION_PROBABILITY = 0.05
GENES_TO_MUTATE = 3

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

def mutate(individual)
  new_genes = individual.genes.dup
  if MUTATION_PROBABILITY <= 0.05
    GENES_TO_MUTATE.times do
      position = (rand * 100).floor
      new_genes[position] = (rand * 10).ceil
    end
  end
  Individual.new(new_genes)
end

population = Population.new(POPULATION_SIZE)


100.times do
  puts "Fitness score: #{ population.fitness_score }"
  new_population = []

  population.size.times do
    parent1 = select_parent(population)
    parent2 = select_parent(population)

    child1, child2 = crossover(parent1, parent2)

    mutated_child1 = mutate(child1)

    matchup = Matchup.new(child1, mutated_child1)
    if matchup.winner == mutated_child1
      child1 = mutated_child1
    end

    mutated_child2 = mutate(child2)

    matchup = Matchup.new(child2, mutated_child2)
    if matchup.winner == mutated_child2
      child2 = mutated_child2
    end

    new_population += [child1, child2]
  end

  population = Population.new(POPULATION_SIZE, new_population)
end

puts population
puts "Fitness score: #{ population.fitness_score }"
