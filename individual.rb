require './gene'
require './matchup'
require 'securerandom'

MUTATION_PROBABILITY = 0.15
GENES_TO_MUTATE = 3

class Individual
  attr_reader :id, :genes

  def initialize(_genes=nil)
    @id = SecureRandom.hex(10)

    if _genes.nil?
      @genes = (1..100).map do |i|
        (rand * 10).ceil
      end
    else
      @genes = _genes
    end
  end

  def self.from_hash(hash)
    _genes = []

    hash.each do |castle, count|
      count.times do
        _genes.push(castle)
      end
    end

    self.new(_genes)
  end

  def self.build_equal_weight_individual
    _genes = []
    (1..10).each do |i|
      _genes += Array.new(10, i)
    end

    Individual.new(_genes)
  end

  @@equal_weight_individual = build_equal_weight_individual

  def to_s
    (1..10).map do |i|
      "#{i.to_s.rjust(2, ' ')}: #{genes.select { |g| g == i }.size.to_s.rjust(3, ' ')}"
    end.join(", ")
  end

  def phalanx_count_for_castle(number)
    genes.select { |g| g == number }.size
  end

  def mutate
    if rand < MUTATION_PROBABILITY
      new_genes = genes.dup
      GENES_TO_MUTATE.times do
        position = (rand * 100).floor
        new_genes[position] = (rand * 10).ceil

        mutated_child = Individual.new(new_genes)

        if mutated_child.fitness_score > self.fitness_score
          return mutated_child
        end
      end
    end

    self
  end

  def fitness_score
    @fitness_score ||= build_fitness_score
  end

  private
  def build_fitness_score
    matchup = Matchup.new(self, @@equal_weight_individual)
    matchup.winner
    matchup.score_differential
  end
end
