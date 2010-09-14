require 'open-uri'
class GamesController < ApplicationController
  respond_to :xml, :json, :xls
  
  def index
    doc = Nokogiri::XML open("http://svenskaspel.se/xternal/XMLkupong.asp?produktid=5")
    @games = []
    doc.css("row").each do |row|
      match = row.at_css("match")
      if Date.parse(match[:start]) == Date.today and match[:sport_name] == "Fotboll"
        @games.push({
          :matchid =>   match[:id],
          :start =>     match[:start],
          :leag =>      match[:league_name],
          :home =>      match.at_css("home_team")[:name],
          :away =>      match.at_css("away_team")[:name],
          :ods_1 =>     row.at_css("alternative[name='1']")[:odds].to_f,
          :ods_x =>     row.at_css("alternative[name='X']")[:odds].to_f,
          :ods_2 =>     row.at_css("alternative[name='2']")[:odds].to_f,
          :stats =>     Game.statistics(match[:id])
        })
      end
    end
    respond_with @games
  end
  
  def statistics
    matchid = params[:matchid]
    stats = Game.statistics(matchid)
    respond_with [stats]
  end
end
