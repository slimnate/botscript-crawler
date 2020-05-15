namespace :osbot do

  desc "TODO"
  task crawl: :environment do
    #alias properties
    osbot = Clients::OSBot
    SELECTORS = osbot::SELECTORS
    URLS = osbot::URLS

    client = Client.find_or_create_by(name: Clients::OSBot::SOURCE_NAME) do |c|
      p "new client: #{c.name}"
    end
    client.url = URLS[:home]
    client.save

    #set up driver
    browser = Selenium::WebDriver.for :chrome
    osbot.use_browser(browser)
    byebug

    #navigate to home page
    osbot.load_home

    # log in if needed
    if not osbot.is_logged_in
      osbot.login
    end

    #crawl free scripts
    browser.get(osbot::URLS[:free_scripts])
    osbot.wait_for_element(*SELECTORS[:categories])

    categoryUrls = []
    categoryElements = browser.find_elements(*SELECTORS[:categories])
    categoryElements.each do |categoryElement|
      categoryUrls << categoryElement.attribute('href')
    end

    #process each category
    categoryUrls.each_with_index do |url, i|
      categoryName = categoryElements[i].text
      next if categoryName == "My Collection"

      #find_or_create category/skill records

      #get category page
      browser.get(url)
      client.wait_for_element(SELECTORS[:free_scripts])

      scriptElements = browser.find_elements(SELECTORS[:free_scripts])
      scriptElements.each do |scriptElement|

      end

    end

    p "finished"

    #crawl paid scripts URLS[:paid_scripts]
  end

end
