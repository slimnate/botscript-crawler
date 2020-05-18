#Struct representing a script section link
ScriptSection = Struct.new(:name, :url)

#Base class that provides default functionality for all script crawlers
class ScriptCrawler

  DEFAULT_WAIT_TIMEOUT = 5

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

  def self.get_and_wait_for(url, selectorType, selector, timeout=DEFAULT_WAIT_TIMEOUT)
    @@browser.get(url)
    self.wait_for_element(selectorType, selector, timeout)
  end

  #waits for a specified element on the page with optional timout override.
  #Timeout defaults to 5 seconds
  def self.wait_for_element(selectorType, selector, timeout=DEFAULT_WAIT_TIMEOUT)
    wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
    wait.until {
        element = @@browser.find_element(selectorType, selector)
        if selector.include?('button')
          element if element.enabled? or element.displayed?
        else
          element if element.displayed?
        end
    }
  end

  #scrolls page to specified elements location
  def self.scroll_to(element)
    @@browser.execute_script("window.scrollTo(0, #{element.location.y})")
  end

  #clicks on `targetElement` and types `text` after waiting for `clickTypeWaitTime` seconds (default 0.05s)
  def self.type(targetElement, text, clickTypeWaitTime=0.05)
    targetElement.click
    sleep clickTypeWaitTime
    targetElement.send_keys(text)
  end

end
