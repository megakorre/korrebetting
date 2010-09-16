class BettradarIdsPage < WebPage
  url "https://stats.betradar.com/statistics/svenskaspel/?clientmatchid=:match&language=se"
  
  def ids
    url = page.css("frame[name='text']").first[:src]
    { :match => url.split("matchid%3D").last.split("&").first, :table => url.split("tableid%3D").last.split("%").first }
  end
end