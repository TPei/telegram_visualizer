# visualize telegram chat history

## visualize messages per week per user in chat
Visualize messages per week per user in your telegram chats. Who writes
more, you or your girlfriend ;)

![demo_graph](https://raw.githubusercontent.com/TPei/telegram_visualizer/master/messages_per_week.png)

Supported visualizations (per chat):
- [x] messages per week per user
- [ ] words per week per user
- [ ] average number of words per message per user (over time?)
- [ ] ?

## Installation
`bundle install` to install the required gems

You might need to run `sudo apt install imagemagick libmagickwand-dev` to get rmagick working

## Prerequisites
Dump your telegram history with (this script)[https://github.com/tvdstaaij/telegram-history-dump] to json

## Usage
`ruby visualize.rb`

Look in awe at the totally super graph

## TODO:
- [x] make this versatile for all users, any chat size
- [x] ask for chat history .jsonl file
- [ ] fix image size issue
- [ ] maybe find a better graphing lib
