require './population'
require './tournament'
require './individual'

TOURNAMENT_SIZE = 8
POPULATION_SIZE = 100

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

population = Population.new(POPULATION_SIZE)


100.times do
  puts "Fitness score: #{ population.fitness_score }"
  new_population = []

  population.size.times do
    parent1 = select_parent(population)
    parent2 = select_parent(population)

    new_population += crossover(parent1, parent2)
  end

  population = Population.new(POPULATION_SIZE, new_population)
end

puts population
puts "Fitness score: #{ population.fitness_score }"
