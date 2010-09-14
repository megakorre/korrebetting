require 'open-uri'
class GamesController < ApplicationController
  respond_to :xml, :json
  
  def index
    doc = Nokogiri::XML open("http://svenskaspel.se/xternal/XMLstartlista.asp?produktid=5")
    games = []
    doc.css("row").each do |row|
      match = row.at_css("match")
      unless Date.parse(match[:start]) != (Date.today - 1.day) and match[:sport_name] != "Fotboll"
        games.push({
          :matchid => match[:id],
          :home => match.at_css("home_team")[:name],
          :away => match.at_css("away_team")[:name],
          :ods_1 => row.at_css("alternative[name='1']")[:odds],
          :ods_x => row.at_css("alternative[name='X']")[:odds],
          :ods_2 => row.at_css("alternative[name='2']")[:odds]
        })
      end
    end
    respond_with games
  end
  
  def rename
    matchid = params[:matchid]
    home, away = Game.rename(matchid)
    respond_with [{
      :home => home,
      :away => away
    }]
  end
end
