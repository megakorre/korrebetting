class Game
  
  def self.betradar_ids(match)
    doc = Nokogiri::HTML(open("https://stats.betradar.com/statistics/svenskaspel/?clientmatchid=#{match}&language=se"))
    url = doc.css("frame[name='text']").first[:src]
    { :match => url.split("matchid%3D").last.split("&").first, :table => url.split("tableid%3D").last.split("%").first }
  end
  
  # url in the frame[name=text]
  # frameset_menumain.php?menupage=guth_statisticsIndex&topage=guth_statistics_headtohead
  # &menuparams=%26tableid%3D4582%26matchid%3D1475705&toparams=%26tableid%3D4582%26matchid%3D1475705&language=se
  def self.rename(match)
    bettids = betradar_ids(match)
    doc = Nokogiri::HTML open("https://stats.betradar.com/statistics/svenskaspel/main.php?page=guth_statistics_headtohead&tableid=#{bettids[:table]}&matchid=#{bettids[:match]}&language=se")
    home = doc.css("table.table_whole.leaguetable_table tr.headtohead_formtable_home td.leaguetable_td_teamName").first.text
    away = doc.css("table.table_whole.leaguetable_table tr.headtohead_formtable_away td.leaguetable_td_teamName").first.text
    [home.strip, away.strip]
  end
  
  def self.statistics(match)
    bettids = betradar_ids(match)
    doc = Nokogiri::HTML open("https://stats.betradar.com/statistics/svenskaspel/main.php?page=guth_statistics_headtohead&tableid=#{bettids[:table]}&matchid=#{bettids[:match]}&language=se")
    home = parse_statistics(doc, :home)
    away = parse_statistics(doc, :away)
    { :home => home, :away => away }
  end
  
  def self.col(cols, id)
    cols[id].text.strip
  end
  
  def self.parse_statistics(doc, pos)
    row = doc.at_css("table.table_whole.leaguetable_table tr.headtohead_formtable_#{pos}")
    cols = row.css("td")
    {
      :team =>            col(cols,2),
      :total_games =>     col(cols,3),
      :total_victorys =>  col(cols,4),
      :total_equal =>     col(cols,5),
      :total_losses =>    col(cols,6),
      :total_goals =>     col(cols,8),
      :away_games =>      col(cols,9),
      :away_victorys =>   col(cols,10),
      :away_equal =>      col(cols,11),
      :away_losses =>     col(cols,12),
      :away_goals =>      col(cols,13),
      :home_games =>      col(cols,14),
      :home_victorys =>   col(cols,15),
      :home_equal =>      col(cols,16),
      :home_losses =>     col(cols,17),
      :home_goals =>      col(cols,18)
    }
  end
end