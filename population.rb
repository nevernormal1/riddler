require './individual'

class Population
  attr_reader :size

  def self.build_equal_weight_individual
    genes = []
    (1..10).each do |i|
      genes += Array.new(10, i)
    end

    Individual.new(genes)
  end

  @@equal_weight_individual = build_equal_weight_individual

  def initialize(size, individuals=[])
    @size = size

    if individuals.empty?
      @individuals = []

      @size.times do
        @individuals.push(Individual.new)
      end
    else
      @individuals = individuals
    end
  end

  def to_s
    @individuals.map.with_index do |individual, index|
      "Individual #{index.to_s.rjust(2, "0")}: #{individual.to_s}"
    end.join("\n")
  end

  def random_subset(n)
    @individuals.shuffle[0..n-1]
  end

  def fitness_score
    @individuals.map do |individual|
      matchup = Matchup.new(individual, @@equal_weight_individual)
      matchup.winner
      matchup.score_differential
    end.sum / @individuals.size
  end
end
