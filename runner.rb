require './population'
require './tournament'

population = Population.new

tournament_players = population.random_subset(4)
tournament = Tournament.new(tournament_players)
winner = tournament.winner
puts "Tournament winner is #{winner}"
