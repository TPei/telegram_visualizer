require 'gruff'
require 'json'

# TODO: ask for filename input
text = File.read('/home/tpei/Code/tg/telegram-history-dump/output/json/Merle.jsonl')
messages = []

text.each_line do |line|
  messages << line
end

# TODO: make generic hash with empty array as base value
# messages_hash = Hash.new([])
messages_hash = { Thomas: [], Merle: [] }

# gather relevant data
messages.each do |message|
  msg = eval(message)
  sender = msg[:from][:first_name].to_sym
  le_hash = { text: msg[:text], date: msg[:date] }

  messages_hash[sender] << le_hash
end

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

g = Gruff::Line.new(2000)
g.title = 'Messages per week!'

week_label_hash = {}
# TODO: make generic hash with empty array as base value
week_messages[:Thomas].each_with_index do |week, index|
  week_label_hash[index] = week[0]
end

# TODO: make generic hash with empty array as base value
datas = { Thomas: [], Merle: [] }
week_messages.each do |name, weeks|
  weeks.each do |weekname, msg_count|
    datas[name] << msg_count
  end
end

g.labels = week_label_hash

datas.each do |key, values|
  g.data(key, values)
end

g.write('messages_per_week.png')
