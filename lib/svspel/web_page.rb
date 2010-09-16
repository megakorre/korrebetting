class WebPage
  def self.url(u, opts = {})
    @@url = u
    @@as_xml = opts[:as_xml] or false
  end
    
  def initialize(args = {})
    @url_args = args
  end
    
    
  def page
    if @web_page
      @web_page
    else
      web_url = @@url
      @url_args.each_pair do |key,value|
         web_url = web_url.replace(":#{key}", value)
      end
      if @@as_xml
        @web_page = Nokogiri::HTML open(web_url)
      else
        @web_page = Nokogiri::XML open(web_url)
      end    
    end
  end
end