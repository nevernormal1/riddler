require './gene'

class Individual
  def initialize
    phalanxes_remaining = 100

    @genes = (1..10).map do |i|
      phalanx_count = (rand * phalanxes_remaining).ceil
      phalanxes_remaining -= phalanx_count
      phalanx_count
    end.shuffle.map.with_index do |phalanx_count, index|
      Gene.new(value: index + 1, phalanxes: phalanx_count)
    end

    def to_s
      @genes.map(&:to_s).join(", ")
    end
  end
end
