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
      link_free_scripts: [:xpath, '//ul[@id="jsddm"]/li[3]'],
      link_premium_scripts: [:xpath, '//ul[@id="jsddm"]/li[5]'],

      #login page elements
      login_username_field: [:xpath, '//input[@id="auth"]'],
      login_password_field: [:xpath, '//input[@id="password"]'],
      login_remember_me: [:xpath, '//input[@id="remember_me_checkbox"]'],
      login_button: [:xpath, '//button[@name="_processLogin"]'],

    }

    #loads the home page and returns once the page has loaded,
    #timing out after 20 seconds if not
    def self.load_home
      @@browser.get(URSL[:home])
      self.wait_for_element(*SELECTORS[:link_free_scripts], 20)
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
      browser.get(URLS[:login])

      #wait for page load
      self.wait_for_element(*SELECTORS[:login_button])

      #go back to home page
      self.load_home
    end

    #waits for a specified element on the page with optional timout override.
    #Timeout defaults to 5 seconds
    def self.wait_for_element(selectorType, selector, timeout=5)
      wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
      wait.until {
          element = @@browser.find_element(selectorType, selector)
          element if element.displayed?
      }
    end

  end #end class OSBot

end
