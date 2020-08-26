#main.rb v.3.0 OOP with threads
require_relative 'lib/question'
require_relative 'lib/quiz'

xml_path = File.join(__dir__, "data", "qa.xml")
unless File.exist?(xml_path)
  puts "File not found! Sorry."
  exit
end

game = Quiz.read_from_xml(xml_path)

game.questions.each_with_index do |question, index|
  puts question

  # get user input with timer
  user_input = Thread.new do
    print "Choose a number of the answer (1 - 4): "
    Thread.current[:value] = STDIN.gets.to_i
  end
  # thread for timer
  Thread.new { sleep question.time_for_answer; user_input.kill }

  user_input.join
  unless user_input[:value]
    puts "\n\nTime is over. Buy-buy..."
    puts game.result
    exit
  end

  if question.correct_answered?(user_input[:value] - 1)
    game.points_up!(index)
    game.right_answers_count += 1
    puts "You are right!!!"
  else
    puts "Wrong answer. The correct answer is #{question.show_correct_answer}"
  end
  puts
end
puts "Congratulations!!"
puts game.result
