require './gene'
require './matchup'
require 'securerandom'

MUTATION_PROBABILITY = 0.15
GENES_TO_MUTATE = 3

class Exemplars
  def self.equal_weight_individual
    genes = []
    (1..10).each do |i|
      genes += Array.new(10, i)
    end

    Individual.new(genes)
  end

  def self.top_heavy_individual
    genes = []

    (6..10).each do |i|
      genes += Array.new(20, i)
    end

    Individual.new(genes)
  end

  def self.gradient_individual
    Individual.from_hash({
      1 => 1,
      2 => 2,
      3 => 4,
      4 => 6,
      5 => 8,
      6 => 10,
      7 => 12,
      8 => 17,
      9 => 19,
      10 => 21,
    })
  end
end

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

  @@exemplars = [
    Exemplars.equal_weight_individual,
    Exemplars.top_heavy_individual,
    Exemplars.gradient_individual,
  ]

  private
  def build_fitness_score
    @@exemplars.map do |exemplar|
      matchup = Matchup.new(self, exemplar)
      matchup.winner
      matchup.score_differential
    end.sum / @@exemplars.size.to_f
  end
end
