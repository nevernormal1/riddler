require './individual'

class Population
  INITIAL_SIZE = 100

  def initialize
    @individuals = []

    INITIAL_SIZE.times do
      @individuals.push(Individual.new)
    end
  end

  def to_s
    @individuals.map.with_index do |individual, index|
      "Individual #{index.to_s.rjust(2, "0")}: #{individual.to_s}"
    end.join("\n")
  end
end
