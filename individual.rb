require './gene'
require './matchup'
require 'securerandom'

MUTATION_PROBABILITY = 0.1
GENES_TO_MUTATE = 3

class Individual
  attr_reader :id, :genes

  def initialize(genes=nil)
    @id = SecureRandom.hex(10)

    if genes.nil?
      @genes = (1..100).map do |i|
        (rand * 10).ceil
      end
    else
      @genes = genes
    end
  end

  def to_s
    @genes.join(", ")
  end

  def phalanx_count_for_castle(number)
    @genes.select { |g| g == number }.size
  end

  def mutate
    if rand <= MUTATION_PROBABILITY
      new_genes = genes.dup
      GENES_TO_MUTATE.times do
        position = (rand * 100).floor
        new_genes[position] = (rand * 10).ceil
      end

      mutated_child = Individual.new(new_genes)

      matchup = Matchup.new(self, mutated_child)
      if matchup.winner == mutated_child
        return mutated_child
      end
    end

    self
  end
end
