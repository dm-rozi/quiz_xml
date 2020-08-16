#main.rb v.3.0 OOP with threads

require_relative 'lib/question_collection'

xml_path = File.join(__dir__, "data", "qa.xml")
# xml_path = file_path + "/qa.xml"

unless File.exist?(xml_path)
  puts "File not found! Sorry."
  exit
end

quiz_points_sum = 0
right_answers_count = 0

puts "Welcome, User. You should answer for 6 questions."
puts

questions = QuestionCollection.read_from_xml(xml_path).shuffle
questions.each.with_index(1) do |question, i|
  puts "You will get #{question.points} points."
  puts question
  puts question.show_variants
  puts
  puts "Hurry up! You have only #{question.time_for_answer} seconds to answer the question."

  # get user_input using thread
  user_input = Thread.new do
    print "Choose a number of the answer (1 - 4): "
    Thread.current[:value] = STDIN.gets.to_i
  end
  # thread for timer
  Thread.new { sleep question.time_for_answer; user_input.kill }

  user_input.join
  unless user_input[:value]
    puts "\n\nTime is over. Buy-buy..."
    puts "Number of the right answers is #{right_answers_count}.\nYou`ve got #{quiz_points_sum} points."
    exit
  end

  if question.correct_answered?(user_input[:value] - 1)
    quiz_points_sum += question.points
    right_answers_count += 1
    puts "You are right!!!"
  else
    puts "Wrong answer. The correct answer is #{question.show_correct_answer}"
  end
  puts
  sleep 1
end
puts "Congratulations!!"
puts "Number of the right answers is #{right_answers_count}.\nYou`ve got #{quiz_points_sum} points."
