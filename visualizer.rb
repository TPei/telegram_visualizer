require 'gruff'
require 'json'

# TODO: ask for filename input
messages = File.read('/home/tpei/Code/tg/telegram-history-dump/output/json/Merle.jsonl').split("\n")

### ==== gather relevant data ==== ####
# empty array for every user
messages_hash = Hash.new { |h,k| h[k] = Array.new }

messages.each do |message|
  msg = eval(message)
  sender = msg[:from][:first_name].to_sym
  transformed_hash = { text: msg[:text], date: msg[:date] }

  messages_hash[sender] << transformed_hash
end

### ==== transform data to week-oriented format ==== ####
week_messages = {}

messages_hash.each do |name, messages|
  # create a week_name => 0 hash per user
  week_messages[name] = Hash.new(0)
  # sort messages by date
  messages.sort_by! { |hsh| hsh[:date] }

  messages.each do |message|
    # create week_name string
    msg_week = Time.at(message[:date]).strftime('%W-%Y')
    # count messages per user per week
    week_messages[name][msg_week] += 1
  end
end

### === create label hash required by gruff { 0 => label0, 1 => label1 } === ###
week_label_hash = {}
week_messages.values.sample.each_with_index do |week, index|
  week_label_hash[index] = week[0]
end


### === count messages per week per user === ###
# empty array for every user
datas = Hash.new { |h,k| h[k] = Array.new }

week_messages.each do |name, weeks|
  weeks.each do |weekname, msg_count|
    datas[name] << msg_count
  end
end

### === create the graph === ###
# create graph
g = Gruff::Line.new(2000)
g.title = 'Messages per week!'
g.labels = week_label_hash

datas.each do |key, values|
  g.data(key, values)
end

g.write('messages_per_week.png')
