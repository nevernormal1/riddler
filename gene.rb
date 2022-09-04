class Gene
  attr_reader :value, :phalanxes

  def initialize(value:, phalanxes:)
    @value, @phalanxes = value, phalanxes
  end

  def to_s
    "#{ @value.to_s.rjust(2, " ") }: #{ @phalanxes.to_s.rjust(3, " ") }"
  end
end
