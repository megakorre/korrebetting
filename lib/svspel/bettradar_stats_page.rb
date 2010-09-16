class BettradarStatsPage < WebPage
  url "https://stats.betradar.com/statistics/svenskaspel/main.php?page=" + 
      "guth_statistics_headtohead&tableid=:table&matchid=:match&language=se"
  
  def home_stats
    parse_stats(page, :home)
  end
  
  def away_stats
    parse_stats(page, :away)
  end
  
  def parse_stats(doc, pos)
    row = doc.at_css("table.table_whole.leaguetable_table tr.headtohead_formtable_#{pos}")
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
      :away_goals =>      col(cols,20)
    }
  end
end