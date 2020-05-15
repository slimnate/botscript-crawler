#Base class that provides default functionality for all crawler
class ScriptCrawler

  #sets the @@browser variable for this session
  def self.use_browser(browser)
    @@browser = browser
  end

  def self.load_home
    raise "ScriptCrawler.load_home not implemented"
  end
end
