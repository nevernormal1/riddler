require './population'
require './tournament'
require './individual'
require './matchup'

TOURNAMENT_SIZE = 8
POPULATION_SIZE = 500
REPLACEMENT_PERCENTAGE = 0.1
GENERATIONS = 1000
CHAMPION_TOURNAMENT_SIZE = 64
CROSSOVER_ITERATIONS = 5

def select_parent(population)
  tournament_players = population.random_subset(TOURNAMENT_SIZE)
  tournament = Tournament.new(tournament_players)
  tournament.winner
end

def crossover(parent1, parent2)
  CROSSOVER_ITERATIONS.times do
    crossover_point = (rand * 100).floor

    child1_genes = parent2.genes[0...crossover_point]
    child1_genes += parent1.genes[crossover_point..]

    child2_genes = parent1.genes[0...crossover_point]
    child2_genes += parent2.genes[crossover_point..]

    parent1 = Individual.new(child1_genes)
    parent2 = Individual.new(child2_genes)
  end

  [parent1, parent2]
end

def find_champion
  population = Population.new(POPULATION_SIZE)

  GENERATIONS.times do |i|
    if i % 10 == 0
      puts "Fitness score: #{ population.fitness_score }..."
    end

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

  puts "Fitness score: #{ population.fitness_score }"

  contenders = population.strongest(64)

  wins = {}

  contenders.each do |contender|
    wins[contender] = 0
    contenders.each do |other_contender|
      next if contender == other_contender
      m = Matchup.new(contender, other_contender)
      if m.winner == contender
        wins[contender] += 1
      end
    end
  end

  wins = wins.sort_by do |contender, wins|
    wins
  end

  wins.each do |contender, value|
    puts "#{contender.id}: #{value}"
  end



  #tournament = Tournament.new(contenders)
  #champion = tournament.winner

  #puts "Best individual:"
  #puts champion

  #champion
end

find_champion

#champions = []
#CHAMPION_TOURNAMENT_SIZE.times do
#  champions.push(find_champion)
#end
#tournament = Tournament.new(champions)
#overall_champion = tournament.winner
#
#puts "-------------"
#puts "Best overall:"
#puts "-------------"
#puts overall_champion
