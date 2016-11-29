require 'gruff'
require 'json'

### === read history file === ###
puts 'Enter path to chat history [./history.json]'
file_path = gets.chomp
file_path = './history.jsonl' if file_path.empty?

begin
  messages = File.read(file_path).split("\n")
rescue Errno::ENOENT
  puts "ERROR: File not found: #{file_path}"
  exit
end

### ==== gather relevant data ==== ####
puts 'Gathering data'
# empty array for every user
messages_hash = Hash.new { |h,k| h[k] = Array.new }

messages.each do |message|
  # in a jsonl file each line is a json object, eval makes it a hash
  msg = eval(message)
  sender = (msg[:from][:first_name] || 'unknown').to_sym
  transformed_hash = { text: msg[:text], date: msg[:date] }

  messages_hash[sender] << transformed_hash
end

### ==== transform data to week-oriented format ==== ####
puts 'Transforming data to week-oriented format'
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
puts 'Count messages per week per user'
datas = Hash.new { |h,k| h[k] = Array.new }

week_messages.each do |name, weeks|
  weeks.each do |weekname, msg_count|
    datas[name] << msg_count
  end
end

### === create the graph === ###
# create graph
puts 'Generate the graph'
g = Gruff::Line.new('1600x900')
g.title = 'Messages per week!'
g.labels = week_label_hash

datas.each do |key, values|
  g.data(key, values)
end

puts 'Writing file'
g.write('messages_per_week.png')
puts 'All done. Goodbye!'
