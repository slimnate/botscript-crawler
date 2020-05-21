# Bot Script Crawler

Crawls the following bot sites for all scripts and info about the scripts and clients:

- https://osbot.org/
- https://www.powerbot.org/
- https://tribot.org/
- https://www.runemate.com/
- https://dreambot.org/
- https://rspeer.org/
- https://xiabot.com/

## Ruby version
Requires ruby 2.5.7

## System dependencies
- chromedriver
- mysql server

## Configuration
OSBot crawler requires that you login before viewing scripts. Run the following
command from the base application directory to edit the encrypted stored
credentials and add you account info before running crawler:

```
EDITOR="atom --wait" bin/rails credentials:edit
```

## Database creation
Run the following commands to create the initial database structure:
```
rake db:create
rake db:migrate
```

## Database initialization
Run the following command to populate the database with initial skill entries:
```
rake rswiki:skills
```
__Note: You must run this command BEFORE attempting to run any other crawlers__


## Creating a crawler

```
rails generate task <client_name>
```
to generate a new rake task located at: `'./lib/tasks/<client_name>.rb'`

Create a new file for the tasks Client object at: `/lib/clients/<client_name>.rb`

__\<client_name\>.rb :__

```
class Client < ScriptCrawler

end
```
Extending the ScriptCrawler class provides the following methods and properties for use in your crawler script:

`self.chrome_driver` - Create a new `Selenium::WebDriver` for the chrome browser

`self.use_browser(b)` - assigns the `@@browser` property of the client, allowing you to interact with the provided `Selenium::WebDriver` browser from within your custom client methods without passing it as a script parameter every time. Returns assigned browser

`self.driver_for(browserSymbol)` - creates a new webdriver instance for specified browser

`self.chrome_driver` - shortcut for `Selenium::WebDriver.for :chrome`

`self.get_and_wait_for(url, selectorType, selector, timeout=DEFAULT_WAIT_TIMEOUT)` - Shortcut to open a url in browser and wait for a specific element to be shown. Allows you to easily open a page and wait for it to load.


## Crawlers

BotScript Crawler provides the following crawlers that gather script data for individual bot clients:

#### OSBot
`rake osbot:scripts` - Crawl OSBot site for list of scripts

`rake osbot:details` - Crawl each OSBot script page for detailed information about the script

#### Powerbot
`rake powerbot:scripts` - Crawl OSBot site for list of scripts

`rake powerbot:details` - Crawl each OSBot script page for detailed information about the script

#### Tribot
TODO

#### Runemate
TODO

#### Dreambot
TODO

#### RSPeer
TODO

#### Xiabot
TODO

## How to run the test suite
TODO

## Deployment instructions
TODO
