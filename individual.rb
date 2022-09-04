require './gene'
require 'securerandom'

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
end
