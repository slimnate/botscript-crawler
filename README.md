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
OSBot crawler requires that you login before wiewing scripts. Run the following
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

## Crawlers
BotScript Crawler provides the following rake tasks for data collection:

#### OSBot
`rake osbot:scripts` - Crawl OSBot site for list of scripts

`rake osbot:details` - Crawl each OSBot script page for detailed information about the script

#### Powerbot
TODO

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
