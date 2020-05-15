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
      free_scripts: '',
      paid_scripts: ''
    }

    #Hash with all selectors
    SELECTORS = {
      #main page links
      link_login: [:xpath, '//ul[@id="jsddm"]/li[6]'],
      link_free_scripts: [:xpath, '//ul[@id="jsddm"]/li[3]/a'],
      link_paid_scripts: [:xpath, '//ul[@id="jsddm"]/li[5]/a'],

      forum_home: [:xpath, '//a[@title="Home"]'],

      #login page elements
      login_username_field: [:xpath, '//input[@id="auth"]'],
      login_password_field: [:xpath, '//input[@id="password"]'],
      login_remember_me: [:xpath, '//input[@id="remember_me_checkbox"]'],
      login_button: [:xpath, '//button[@id="elSignIn_submit"][last()]'],

      #free_scripts
      categories: '//div[@class="categories"]/a',
      free_scripts: '//div[@class="basic_script"]'
    }

    #loads the home page and returns once the page has loaded,
    #timing out after 20 seconds if not
    def self.load_home
      @@browser.get(URLS[:home])
      self.wait_for_element(*SELECTORS[:link_free_scripts], 20)


      freeScriptLinkElement = @@browser.find_element(*SELECTORS[:link_free_scripts])
      paidScriptLinkElement = @@browser.find_element(*SELECTORS[:link_paid_scripts])
      URLS[:free_scripts] = freeScriptLinkElement.attribute('href')
      URLS[:paid_scripts] = paidScriptLinkElement.attribute('href')
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

      @@browser.execute_script("window.scrollTo(0, #{usernameElement.location.y})")

      #input and submit
      usernameElement.click
      usernameElement.send_keys(USERNAME)
      passwordElement.click
      passwordElement.send_keys(PASSWORD)

      submitElement[1].click

      self.wait_for_element(*SELECTORS[:forum_home])
    end

    #waits for a specified element on the page with optional timout override.
    #Timeout defaults to 5 seconds
    def self.wait_for_element(selectorType, selector, timeout=5)
      wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
      wait.until {
          element = @@browser.find_element(selectorType, selector)
          if selector.include?('button')
            element if element.enabled?
          else
            element if element.displayed?
          end
      }
    end

  end #end class OSBot

end
