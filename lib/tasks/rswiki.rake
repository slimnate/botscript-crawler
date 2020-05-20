namespace :rswiki do
  desc "Get list of OSRS skills from the wiki"
  task skills: :environment do
    SKILLS_URL = 'https://oldschool.runescape.wiki/w/Skills'
    SELECTORS = {
      free_skills: [:xpath, '//table[1]/tbody/tr'],
      member_skills: [:xpath, '//table[2]/tbody/tr'],
      icon: [:xpath, './td[1]/a/img'],
      name: [:xpath, './td[2]/a'],
      desc: [:xpath, './td[3]']
    }

    browser = Selenium::WebDriver.for :chrome

    browser.get(SKILLS_URL)

    #wait for page load, 10 sec timeout
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until {
        element = browser.find_element(*SELECTORS[:free_skills])
        element if element.displayed?
    }

    #get free skills
    freeSkillElements = browser.find_elements(*SELECTORS[:free_skills])
    freeSkillElements.each do |skillElement|
      #get elements
      iconElement = skillElement.find_element(*SELECTORS[:icon])
      nameElement = skillElement.find_element(*SELECTORS[:name])
      descElement = skillElement.find_element(*SELECTORS[:desc])

      #parse data from elements
      icon = iconElement.attribute('src')
      name = nameElement.text
      wikiLink = nameElement.attribute('href')
      description = descElement.text

      #create or find existing skill by name
      skill = Skill.find_or_create_by(name: name) { p "skill created" }

      #update the skill with parsed values
      skill.description = description
      skill.icon_url = icon
      skill.wiki_url = wikiLink
      skill.members_only = false

      #save skill
      skill.save

      p "Skill - #{skill.name} - #{skill.description} - #{skill.members_only ? 'Members only' : 'Free to play'}"

    end #end freeSkillElements.each

    #get memeber skills
    memberSkillElements = browser.find_elements(*SELECTORS[:member_skills])
    memberSkillElements.each do |skillElement|
      #get elements
      iconElement = skillElement.find_element(*SELECTORS[:icon])
      nameElement = skillElement.find_element(*SELECTORS[:name])
      descElement = skillElement.find_element(*SELECTORS[:desc])

      #parse data from elements
      icon = iconElement.attribute('src')
      name = nameElement.text
      wikiLink = nameElement.attribute('href')
      description = descElement.text

      #create or find existing skill by name
      skill = Skill.find_or_create_by(name: name) { p "skill created" }

      #update the skill with parsed values
      skill.description = description
      skill.icon_url = icon
      skill.wiki_url = wikiLink
      skill.members_only = true

      #save skill
      skill.save

      p "Skill - #{skill.name} - #{skill.description} - #{skill.members_only ? 'Members only' : 'Free to play'}"

    end #end freeSkillElements.each

    p "finished"
  end
end
