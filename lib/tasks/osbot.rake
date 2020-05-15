namespace :osbot do
  desc "TODO"
  task crawl: :environment do
    #set up driver
    browser = Selenium::WebDriver.for :chrome
    Clients::OSBot.use_browser(browser)

    #navigate to home page
    Clients::OSBot.load_home

    # log in if needed
    if not Clients::OSBot.is_logged_in
      Clients::OSBot.login
    end

    #crawl free scripts
    

    #crawl paid scripts
  end

end
