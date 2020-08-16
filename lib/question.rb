require 'rexml/document'

class Question
  attr_reader :points, :time_for_answer

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
    questions
  end

  def initialize(question_text, answers, right_answer_index, time_for_answer, points)
    @question_text = question_text
    @answers = answers
    @right_answer_index = right_answer_index.to_i
    @time_for_answer = time_for_answer.to_i
    @points = points.to_i
  end

  def show_question
    @question_text
  end

  def show_variants
    @variants_list = @answers.shuffle
    @variants_list.map.with_index(1) { |variant, i| "#{i}. #{variant}" }.join("\n")
  end

  def correct_answered?(user_answer)
    true if @variants_list[user_answer] == @answers[@right_answer_index]
  end

  def show_correct_answer
    @answers[@right_answer_index]
  end
end
