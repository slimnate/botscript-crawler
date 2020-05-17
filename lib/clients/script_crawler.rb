#Struct representing a script category link
ScriptCategory = Struct.new(:name, :url)

#Base class that provides default functionality for all script crawlers
class ScriptCrawler

  self.DEFAULT_WAIT_TIMEOUT = 5

  #create a new `Selenium::WebDriver` for specified browser
  def self.driver_for(browserSymbol)
    return Selenium::WebDriver.for browserSymbol
  end

  #create a new `Selenium::WebDriver` for chrome
  def self.chrome_driver
    return self.driver_for :chrome
  end

  #set the @@browser property for this crawler session and return the set browser
  def self.use_browser(b)
    @@browser = b
    return @@browser
  end
  end

  def self.load_home
    raise "ScriptCrawler.load_home not implemented"
  end
end
