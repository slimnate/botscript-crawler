namespace :osbot do

  desc "TODO"
  task scripts: :environment do
    #alias properties
    osbot = Clients::OSBot
    SELECTORS = osbot::SELECTORS
    URLS = osbot::URLS

    #set up driver
    browser = osbot.use_browser(osbot.chrome_driver)

    #find/create client entry
    client = Client.find_or_create_by(name: Clients::OSBot::SOURCE_NAME) do |c|
      p "new client: #{c.name}"
    end
    client.url = URLS[:home]
    client.save

    #navigate to client home page and log in
    osbot.load_home
    osbot.login unless osbot.is_logged_in

    #go to scripts page
    browser.get(osbot::URLS[:scripts])
    osbot.wait_for_element(*SELECTORS[:categories])

    scriptCategories = []
    categoryElements = browser.find_elements(*SELECTORS[:categories])
    categoryElements.each do |categoryElement|
      c = ScriptCategory.new(categoryElement.text, categoryElement.attribute('href'))
      scriptCategories << c
    end

    #process each category
    scriptCategories.each_with_index do |scriptCategory, i|
      next if scriptCategory.name == "My Collection"

      #find_or_create category/skill records

      #get category page
      browser.get(url)
      client.wait_for_element(SELECTORS[:free_scripts])

      scriptElements = browser.find_elements(SELECTORS[:free_scripts])
      scriptElements.each do |scriptElement|

      end

    end

    p "finished"
  end

  desc "Scrape script details from each script link"
  task details: :environment do
    #TODO: implement detail scraping for each script
  end

end
