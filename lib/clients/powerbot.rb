module Clients
  class Powerbot < ScriptCrawler
    SOURCE_NAME = 'powerbot'

    URLS = {
      home: 'https://www.powerbot.org/',
      scripts: 'https://www.powerbot.org/scripts/',
      icon: 'https://www.powerbot.org/assets/img/logos/arrows.png',
      forum: 'https://www.powerbot.org/community/',
      api: 'https://www.powerbot.org/rsbot/releases/docs/',
      download: 'https://www.powerbot.org/'
    }

    SELECTORS = {
      #script_sections: [:css, '#query-types a'],
      scripts: [:xpath, '//div[contains(@class, "cart-item")]'],

      name: [:css, 'h3'],
      description: [:css, 'div.descr'],
      price: [:css, 'div.row']

    }

    def self.script_sections
      results = []
      sectionElements = @@browser.find_elements(*SELECTORS[:script_sections])
      sectionElements.each do |sectionElement|
        next if sectionElement.text == 'All' or sectionElement.text == 'Mine' or sectionElement.text == "VIP"

        results << ScriptSection.new(sectionElement.text, sectionElement.attribute('href'))
      end

      return results
    end

  end
end
