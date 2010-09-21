class Game
  
  def self.betradar_ids(match)
    doc = Nokogiri::HTML(open("https://stats.betradar.com/statistics/svenskaspel/?clientmatchid=#{match}&language=se"))
    url = doc.css("frame[name='text']").first[:src]
    { :match => url.split("matchid%3D").last.split("&").first, :table => url.split("tableid%3D").last.split("%").first }
  end
    
  # .headtohead_lastmatches_hometd .table_content_td.headtohead_resulttd
  # .headtohead_lastmatches_awaytd .headtohead_lastmatches_matchestable .table_content_td.headtohead_resulttd
  # https://stats.betradar.com/statistics/svenskaspel/main.php?page=guth_statistics_headtohead&numberOfMatches=4
  #  &lastMatchesTypeAway=Total&lastMatchesTypeHome=Home&lastMatchesTournamentTypeAwayTeam=All&lastMatchesTournamentTypeHomeTeam=All&tableid=4267&language=se&numberOfMatches=4&teamidhome=364647&teamidaway=5235&lastMatchesTypeHome=Home&lastMatchesTypeAway=Away  
  
  # &lastMatchesTypeHome=Home&lastMatchesTypeAway=Away&numberOfMatches=6
  #  
    
  def self.statistics(match)
    bettids = betradar_ids(match)
    doc = Nokogiri::HTML open("https://stats.betradar.com/statistics/svenskaspel/main.php?page=guth_statistics_headtohead&tableid=#{bettids[:table]}&matchid=#{bettids[:match]}&language=se&lastMatchesTypeHome=Home&lastMatchesTypeAway=Away&numberOfMatches=6")
    home = parse_statistics(doc, :home)
    away = parse_statistics(doc, :away)
    { :home => home, :away => away, :match => match }
  end
  
  def self.col(cols, id)
    cols[id].text.strip
  end
  
  def self.parse_statistics(doc, pos)
    row = doc.at_css("table.table_whole.leaguetable_table tr.headtohead_formtable_#{pos}")
    if row == nil
      return nil
    end
    cols = row.css("td")
    {
      :team =>            col(cols,2),
      :total_games =>     col(cols,3),
      :total_victorys =>  col(cols,4),
      :total_equal =>     col(cols,5),
      :total_losses =>    col(cols,6),
      :total_goals =>     col(cols,7),
      
      :home_games =>      col(cols,10),
      :home_victorys =>   col(cols,11),
      :home_equal =>      col(cols,12),
      :home_losses =>     col(cols,13),
      :home_goals =>      col(cols,14),
      
      :away_games =>      col(cols,16),
      :away_victorys =>   col(cols,17),
      :away_equal =>      col(cols,18),
      :away_losses =>     col(cols,19),
      :away_goals =>      col(cols,20),
      :last_games =>      parse_last_games(doc, pos)
    }
  end
  
  def self.last_games_css
    { :home => ".headtohead_lastmatches_hometd .table_content_td.headtohead_resulttd",
      :away => ".headtohead_lastmatches_awaytd .headtohead_lastmatches_matchestable .table_content_td.headtohead_resulttd" }
  end
  
  def self.parse_last_games(doc, pos)
    doc.css(last_games_css[pos]).map do |item|
      item.text.strip.split(":").map(&:to_i)
    end
  end
end