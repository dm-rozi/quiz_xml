require 'rexml/document'
require_relative 'question'

class Quiz
  attr_reader :questions, :quiz_points_sum
  attr_accessor :right_answers_count

  def self.read_from_xml(xml_path)
    xml_file = File.read(xml_path, encoding: 'utf-8')
    doc = REXML::Document.new(xml_file)

    questions = []

    doc.elements.each("questions/question/") do |item|
      question_text = ""
      answers = []
      right_answer_index = 0
      time_for_answer = item.attributes["seconds"]
      points = item.attributes["points"]

      item.elements.each do |question_answers|
        case question_answers.name
        when "text"
          question_text = question_answers.text
        when "variants"
          question_answers.elements.each_with_index do |answer, i|
            answers << answer.text
            right_answer_index = i if answer.attributes["right"]
          end
        end
      end
      questions << Question.new(question_text, answers, right_answer_index, time_for_answer, points)
    end
    new(questions.shuffle)
  end

  def initialize(questions)
    @questions = questions
    @right_answers_count = 0
    @quiz_points_sum = 0
  end

  def points_up!(question_index)
    @quiz_points_sum += @questions[question_index].points
  end

  def result
    "Number of the right answers is #{@right_answers_count}.\nYou`ve got #{@quiz_points_sum} points."
  end
end
