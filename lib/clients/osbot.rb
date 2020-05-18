require 'uri'

module Clients

  #OSBot crawler client. Provides helper functions for crawler task
  #and info about the client
  class OSBot < ScriptCrawler
    SOURCE_NAME = 'osbot'

    # credentials - edit: ~$ EDITOR="atom --wait" bin/rails credentials:edit
    USERNAME = Rails.application.credentials[:osbot][:username]
    PASSWORD = Rails.application.credentials[:osbot][:password]

    #Hash for urls
    URLS = {
      home: 'https://www.osbot.org/',
      login: 'https://osbot.org/forum/login/',
      scripts: 'https://osbot.org/mvc/sdn2/scripts/'
    }

    #Hash with all selectors
    SELECTORS = {
      #main page links
      home_menu: [:xpath, '//ul[@id="jsddm"]'],

      #login
      login_username_field: [:xpath, '//input[@id="auth"]'],
      login_password_field: [:xpath, '//input[@id="password"]'],
      login_remember_me: [:xpath, '//input[@id="remember_me_checkbox"]'],
      login_button: [:xpath, '//button[@id="elSignIn_submit"][last()]'],
      forum_home: [:xpath, '//a[@title="Home"]'],

      categories: [:xpath, '//div[@class="categories"]/a'],

      #all scripts
      scripts: [:css, '.basic_script'],
      script_title: [:css, '.basic_script_desc'],
      script_author: [:css, '.basic_script_author'],
      script_img: [:css, '.basic_script_img'],
      script_add_button: [:css, 'button:first-of-type'],
      script_info_button: [:css, '.button.info'],

      #only on free scripts
      script_users: [:css, '.basic_script_numusers'],

      #only on paid scripts
      script_price_base: [:css, '.basic_script_price'],
      script_price_renew: [:css, '.basic_script_price2'] #optional

    }

    #loads the home page and returns once the page has loaded,
    #timing out after 20 seconds if not
    def self.load_home
      self.get_and_wait_for(URLS[:home], *SELECTORS[:home_menu], 20)
    end

    #returns true if currently logged in to site, false otherwise
    def self.is_logged_in
      begin
        loginCookie = @@browser.manage.cookie_named('ips4_loggedIn')
        p loginCookie[:value]
        return loginCookie[:value] == '1'
      rescue Selenium::WebDriver::Error::NoSuchCookieError => e
        #not logged in if cookie does not exist
        return false
      end
    end

    #logs in to the site and then navigates back to the home page.
    def self.login
      #go to login page
      self.get_and_wait_for(URLS[:login], *SELECTORS[:login_button], 15)

      #find elements
      usernameElement = @@browser.find_element(*SELECTORS[:login_username_field])
      passwordElement = @@browser.find_element(*SELECTORS[:login_password_field])
      rememberMeElement = @@browser.find_element(*SELECTORS[:login_remember_me])
      submitElement = @@browser.find_elements(*SELECTORS[:login_button])

      self.scroll_to(usernameElement)

      #input creds and submit
      self.type(usernameElement, USERNAME)
      self.type(passwordElement, PASSWORD)
      submitElement[1].click

      #wait for login to complete, 10s timeout
      self.wait_for_element(*SELECTORS[:forum_home], 10)
    end

    #parse a list of `ScriptCategory` structs from the scripts page
    def self.script_sections
      results = []
      categoryElements = @@browser.find_elements(*SELECTORS[:categories])
      categoryElements.each do |categoryElement|
        #add category to results
        results << ScriptSection.new(
          categoryElement.text,
          categoryElement.attribute('href')
        )
      end
      return results
    end

    #gets data about all scripts on the currently displayed page
    def self.scripts
      results = []

      begin
        #get script elements
        scriptElements = @@browser.find_elements(*SELECTORS[:scripts])
        scriptElements.each do |scriptElement|

          #create initial record hash
          record = {
            name: nil,
            author: nil,
            url: nil,
            addUrl: nil,
            iconUrl: nil,
            price: nil,
            users: nil
          }

          #get basic elements
          begin
            nameElement = scriptElement.find_element(*SELECTORS[:script_title])
            authorElement = scriptElement.find_element(*SELECTORS[:script_author])
            addElement = scriptElement.find_element(*SELECTORS[:script_add_button])
            infoElement = scriptElement.find_element(*SELECTORS[:script_info_button])

            addUrl = addElement.attribute('onclick')
            addUrl = addUrl.gsub('window.location=', '').gsub("'", '')
            addUrl = URI.join(URLS[:home], addUrl).to_s

            infoUrl = infoElement.attribute('onclick')
            infoUrl = infoUrl.gsub('window.location=', '').gsub("'", '')

            record[:name] = nameElement.text.strip
            record[:author] = authorElement.text.gsub('Written by ', '').strip
            record[:addUrl] = addUrl.strip
            record[:url] = infoUrl.strip
          rescue Selenium::WebDriver::Error::NoSuchElementError => e
            # missing basic elements
            p ">>Skipping script element: #{scriptElement.text}"
            p ">>Because of error finding a shared element:"
            p e

            byebug
            next
          end

          #get image
          begin
            imgElement = scriptElement.find_element(*SELECTORS[:script_img])
            iconUrl = imgElement.attribute('style')
            iconUrl = iconUrl.gsub('background-image:', '')
            iconUrl = iconUrl.gsub('url(', '').gsub(');', '').gsub('"', '')

            record[:iconUrl] = iconUrl.strip
          rescue Selenium::WebDriver::Error::NoSuchElementError
            #no image
            p ">>no image for script: #{record[:name]}"
          end

          #get users
          begin
            usersElement = scriptElement.find_element(*SELECTORS[:script_users])
            userCount = usersElement.text.gsub('users', '')

            record[:users] = userCount.strip
          rescue Selenium::WebDriver::Error::NoSuchElementError
            #no users
          end

          #get price
          begin
            price1 = nil
            price2 = nil

            priceBaseElement = scriptElement.find_element(*SELECTORS[:script_price_base])
            price1 = priceBaseElement.text.strip

            priceRenewElement = scriptElement.find_element(*SELECTORS[:script_price_renew])
            price2 = priceRenewElement.text.strip

            if price2 != ""
              record[:price] = "#{price1} - #{price2}"
            else
              record[:price] = price1
            end
          rescue Selenium::WebDriver::Error::NoSuchElementError
            #no prices, no problem
            record[:price] = "Free"
          end

          #add record to results
          p ">>Script found: #{record[:name]}"
          results << record
        end #end scriptElements.each
      rescue Selenium::WebDriver::Error::NoSuchElementError
        p ">>no scripts found on page: #{@@browser.current_url}"
        #no scripts on page
        return []
      end #end main begin/rescue

      #return all results
      return results
    end #end scripts()

  end #end class OSBot

end
