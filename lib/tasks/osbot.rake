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
    osbot.get_and_wait_for(osbot::URLS[:scripts], *SELECTORS[:categories])

    #get script categories
    scriptSections = osbot.script_sections

    #process each category
    scriptSections.each_with_index do |scriptSection, i|

      #skip "My Collection" - it's empty by default
      next if scriptSection.name == "My Collection"
      p "ScriptSection: #{scriptSection}"

      #skill/category records
      skill = nil
      category = nil

      #check if the section is for a skill or a category, create relevant records
      begin
        skill = Skill.find_by!(name: scriptSection.name)
      rescue ActiveRecord::RecordNotFound
        p "no skill found"
        category = Category.find_or_create_by!(name: scriptSection.name) do |c|
          p ">New category created - #{c.name}"
        end
      end

      p ">Skill: #{skill.name}" unless skill == nil
      p ">Category: #{category.name}" unless category == nil

      scriptElements = browser.find_elements(SELECTORS[:free_scripts])
      scriptElements.each do |scriptElement|
      #load category page and get parse scripts
      osbot.get_and_wait_for(url, *SELECTORS[:scripts], 10)

      end

    end

    p "finished"
  end

  desc "Scrape script details from each script link"
  task details: :environment do
    #TODO: implement detail scraping for each script
  end

end
