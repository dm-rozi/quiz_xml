class Question
  attr_reader :points, :time_for_answer

  def initialize(question_text, answers, right_answer_index, time_for_answer, points)
    @question_text = question_text
    @answers = answers
    @right_answer_index = right_answer_index.to_i
    @time_for_answer = time_for_answer.to_i
    @points = points.to_i
  end

  def to_s
    @variants_list = @answers.shuffle
    <<~QUESTION
      You will get #{@points} points.
      #{@question_text}
      #{@variants_list.map.with_index(1) { |variant, i| "#{i}. #{variant}" }.join("\n")}
      
      You have only #{@time_for_answer} seconds to answer this question. Hurry up!
    QUESTION
  end

  def correct_answered?(user_answer)
    @variants_list[user_answer] == @answers[@right_answer_index]
  end

  def show_correct_answer
    @answers[@right_answer_index]
  end
end
