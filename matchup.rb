class Matchup
  def initialize(ind1, ind2)
    @ind1, @ind2 = ind1, ind2
  end

  def winner
    ind1_wins = []
    ind2_wins = []
    splits = []

    (1..10).each do |i|
      ind1_count = @ind1.phalanx_count_for_gene(i)
      ind2_count = @ind2.phalanx_count_for_gene(i)
      if ind1_count > ind2_count
        ind1_wins.push(i)
      elsif ind2_count > ind1_count
        ind2_wins.push(i)
      else
        splits.push(i)
      end
    end

    split_points = splits.map { |i| i.to_f / 2 }.sum

    ind1_score = ind1_wins.sum + split_points
    ind2_score = ind2_wins.sum + split_points

    puts "Ind #{@ind1.id} won #{ ind1_score } points: #{ ind1_wins.join(', ') }"
    puts "Ind #{@ind2.id} won #{ ind2_score } points: #{ ind2_wins.join(', ') }"
    if split_points > 0
      puts "They tied on #{ splits.join(", ") } for #{ split_points } points"
    end

    if ind1_score > ind2_score
      puts "Ind #{@ind1.id} wins"
      return @ind1
    elsif ind2_score > ind1_score
      puts "Ind #{@ind2.id} wins"
      return @ind2
    else
      if rand > 0.5
        puts "Ind #{@ind1.id} wins tie"
        return @ind1
      else
        puts "Ind #{@ind2.id} wins tie"
        return @ind2
      end
    end
  end
end
