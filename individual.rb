require './gene'
require 'securerandom'

class Individual
  attr_reader :id

  def initialize
    @id = SecureRandom.hex(10)

    phalanxes_remaining = 100

    @genes = (1..10).map do |i|
      phalanx_count = (rand * phalanxes_remaining).ceil
      phalanxes_remaining -= phalanx_count
      phalanx_count
    end.shuffle.map.with_index do |phalanx_count, index|
      Gene.new(value: index + 1, phalanxes: phalanx_count)
    end
  end

  def to_s
    @genes.map(&:to_s).join(", ")
  end

  def phalanx_count_for_gene(number)
    @genes[number - 1].phalanxes
  end
end
