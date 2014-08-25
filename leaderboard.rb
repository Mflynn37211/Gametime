require 'csv'
require 'pry'
require 'sinatra'
require 'sinatra/reloader'


##########Methods############

def team_info(team_name)
  teams = []

  CSV.foreach(team_name, headers: true, header_converters: :symbol, converters: :numeric) do |row|
    teams << row.to_hash
  end

  teams
end

def sort_teams(info)
  info.sort_by {|key, value| value}
end

######### Routes ###########

get '/leaderboard' do
  @teams = team_info("teams.csv")
  team_win = Hash.new(0)
  team_loss = Hash.new(0)
  won = []
  lost = []


  @teams.each do |team|
    if team[:away_score] > team[:home_score]
      won << team[:away_team]
    elsif team[:away_score] < team[:home_score]
      won << team[:home_team]
    end
  end

  won.each do |team_wins|
    team_win[team_wins] += 1
  end

  @teams.each do |team|
    if team[:away_score] > team[:home_score]
      lost << team[:home_team]
    elsif team[:away_score] < team[:home_score]
      lost << team[:away_team]
    end
  end

  lost.each do |teamloss|
    team_loss[teamloss] += 1
  end

  @winnners = sort_teams(team_win).reverse
  @losses = sort_teams(team_loss).reverse
  erb :leaderboard
end
