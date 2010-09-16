class SvspelGamesPage < WebPage
  url "http://svenskaspel.se/xternal/XMLkupong.asp?produktid=5", :as_xml => true
  
  def games
    games = []
    page.css("row").each do |row|
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
          :ods_2 =>     row.at_css("alternative[name='2']")[:odds].to_f
        })
      end
    end
    return games
  end
end