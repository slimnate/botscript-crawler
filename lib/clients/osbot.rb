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

      #free_scripts
      categories: [:xpath, '//div[@class="categories"]/a'],
      scripts: [:xpath, '//div[@class="basic_script"]'],
    }

    #loads the home page and returns once the page has loaded,
    #timing out after 20 seconds if not
    def self.load_home
      @@browser.get_and_wait_for(URLS[:home], *SELECTORS[:home_menu].to, 20)
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
      @@browser.get(URLS[:login])

      #wait for page load
      self.wait_for_element(*SELECTORS[:login_button], 15)

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

    end

  end #end class OSBot

end
