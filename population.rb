require './individual'

class Population
  attr_reader :size

  def initialize(size)
    @size = size
    @individuals = []

    @size.times do
      @individuals.push(Individual.new)
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
end
