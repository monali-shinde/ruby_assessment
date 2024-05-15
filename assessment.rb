require 'pstore'

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

def prompt_for_answer(question)
  print "#{question} (Yes/No): "
  answer = gets.chomp.downcase
  until ['yes', 'no', 'y', 'n'].include?(answer)
    print "Please enter Yes or No: "
    answer = gets.chomp.downcase
  end
  answer
end

def do_prompt
  answers = {}
  QUESTIONS.each do |key, question|
    answers[key] = prompt_for_answer(question)
  end
  answers
end

def calculate_rating(answers)
  yes_count = answers.count { |_key, value| ['yes', 'y'].include?(value) }
  (100.0 * yes_count / QUESTIONS.size).round(2)
end

store = PStore.new("tendable.pstore")
ratings = []

loop do
  puts "Starting a new run..."
  answers = do_prompt
  store.transaction do
    store[:answers] = answers
  end

  rating = calculate_rating(answers)
  ratings << rating
  puts "Rating for this run: #{ratings.last}"
  total = ratings.sum
  average_rating = (total / ratings.size.to_f).round(2)
  puts "Average rating for all runs: #{average_rating}"

  print "Do you want to run the survey again? (Yes/No): "
  choice = gets.chomp.downcase
  break unless ['yes', 'y'].include?(choice)
end

puts "Exiting the survey."
