require './matchup'

class Tournament
  def initialize(players)
    raise "Tournament must include at least one player" if players.empty?
    @players = players
  end

  def winner
    players = @players
    while players.length > 1
      players = play_round(players.dup)
    end
    players.first
  end

  private
  def play_round(players)
    #puts "Starting round with #{players.length} players..."
    winners = []
    while !players.empty?
      player1 = players.pop
      player2 = players.pop
      if !player2
        #puts "Player1 wins by default"
        winners.push(player1)
      else
        winners.push Matchup.new(player1, player2).winner
      end
    end
    #puts "Round complete"
    winners
  end
end
