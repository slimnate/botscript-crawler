namespace :powerbot do
  desc "Scrape list of scripts from Powerbot"
  task scripts: :environment do
    #alias properties
    powerbot = Clients::Powerbot
    SELECTORS = powerbot::SELECTORS
    URLS = powerbot::URLS

    #set up driver
    browser = powerbot.use_browser(powerbot.chrome_driver)

    #find/create client entry
    client = Client.find_or_create_by(name: Clients::Powerbot::SOURCE_NAME) do |c|
      p "new client: #{c.name}"
    end

    #save urls
    client.url = URLS[:home]
    client.icon_url = URLS[:icon]
    client.forum_url = URLS[:forum]
    client.apidocs_url = URLS[:api]
    client.download_url = URLS[:download]
    client.save

    #open scripts page
    powerbot.get_and_wait_for(URLS[:scripts], *SELECTORS[:scripts])

    begin
      scriptElements = browser.find_elements(*SELECTORS[:scripts])
      scriptElements.each do |scriptElement|
        #get elements
        nameElement = scriptElement.find_element(*SELECTORS[:name])
        linkElement = nameElement.find_element(:css, 'a')
        descriptionElement = scriptElement.find_element(*SELECTORS[:description])
        iconElement = descriptionElement.find_element(:css, 'div')
        priceElement = scriptElement.find_element(*SELECTORS[:price])

        name = nameElement.text
        next if name == "" #skip hidden elements

        #get data values
        author = nameElement.attribute('title').gsub('by ', '')
        iconClass = iconElement.attribute('class').gsub('pull-left ', '')
        url = linkElement.attribute('href')
        description = descriptionElement.text
        price = priceElement.text
        price = "Free" if price == ""
        categoryName = iconClass.gsub('icon-script icon-script-', '').capitalize

        #get skill if exists
        skill = Skill.find_by(name: categoryName)

        #create category if it's not a skill
        category = nil
        if skill == nil
          category = Category.find_or_create_by(name: categoryName)
        else
          categories = Category.find_by(name: categoryName)
        end
        p skill == nil ? category : skill


        begin
          script = Script.create_with(client: client).find_or_create_by!(url: url) do
            p "created new script for #{name}"
          end
        rescue => e
          #error with creating script, important
          p "error creating script"
          byebug
        end

        #save values to script
        script.name = name.strip
        script.author = author
        script.icon_url = iconClass
        script.description_text = description.strip
        script.price = price.strip
        script.skills << skill unless skill == nil
        script.categories << category unless category == nil
        script.save

        p "script done : #{script.name}"
      end
    rescue => e
      p "general error"
      byebug
    end

    p "finished"
  end

  desc "Scrape details form each script"
  task details: :environment do
    skill = Skill.find_by(name: 'not a skill');
    byebug
  end

end
