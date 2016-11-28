# visualize telegram chat history

## visualize messages per week per user in chat
So far I only hard coded this for one chat with specific usernames

## Installation
`bundle install` to install the required gems

You might need to run `sudo apt install imagemagick libmagickwand-dev` to get rmagick working

## Prerequisites
Get your telegram history with (this gem)[https://github.com/tvdstaaij/telegram-history-dump]

## Usage
`ruby visualize.rb`

Look in awe at the totally super graph

## TODO:
- [x] make this versatile for all users, any chat size
- [x] ask for chat history .jsonl file
- [] fix image size issue
- [] maybe find a better graphing lib
