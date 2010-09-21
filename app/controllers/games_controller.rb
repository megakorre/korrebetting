require 'open-uri'
class GamesController < ApplicationController
  respond_to :xml, :json, :xls

  private
  
  def games_url
    "http://svenskaspel.se/xternal/XMLstartlista.asp?produktid=5"
  end
  
  public

  def document
    @games = []
    for game in JSON.parse(params[:data])
      if game
        @games.push(game)
      end
    end
  end
  
  def info
    @doc = Nokogiri::XML open(games_url)
  end
  
  def index
    doc = Nokogiri::XML open(games_url)
    @games = []
    doc.css("row[type_name='1X2']").each do |row|
      match = row.at_css("match")
      if date?(match[:start]) and match[:sport_name] == "Fotboll"
        @games.push({
          :matchid =>   match[:id],
          :start =>     match[:start],
          :leag =>      match[:league_name],
          :home =>      match.at_css("home_team")[:name],
          :away =>      match.at_css("away_team")[:name],
          :ods_1 =>     row.at_css("alternative[name='1']")[:odds].to_f,
          :ods_x =>     row.at_css("alternative[name='X']")[:odds].to_f,
          :ods_2 =>     row.at_css("alternative[name='2']")[:odds].to_f
        })
      end
    end
    puts @games.count
    respond_with(@games)
  end
  
  def statistics
    stats = Game.statistics(params[:match])
    respond_with [stats]
  end
  
  private
  
  def date?(test)
    date = params[:date] != nil ? Date.parse(params[:date]) : Date.today
    if params[:show_played_games] == "on"
      Date.parse(test) == date
    else
      Date.parse(test) == date && Time.parse(test) > Time.now
    end
  end
end
