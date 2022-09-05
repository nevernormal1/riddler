require './individual'

class Population
  attr_reader :size

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

  def strongest(n)
    @individuals.dup.sort_by(&:fitness_score)[-n..]
  end

  def fitness_score
    @individuals.map(&:fitness_score).sum / @individuals.size.to_f
  end
end
