require 'minitest/autorun'
require 'stringio'
require_relative 'assessment'

class SurveyTest < Minitest::Test
 
  def test_prompt_for_answer_invalid_then_valid
    $stdin = StringIO.new("abc\nno\n")
    assert_equal 'no', prompt_for_answer("Can you code in Ruby?")
  ensure
    $stdin = STDIN
  end

 
  def test_prompt_for_answer_valid_input
    $stdin = StringIO.new("yes\n")
    assert_equal 'yes', prompt_for_answer("Can you code in Ruby?")
  ensure
    $stdin = STDIN
  end

 
  def test_calculate_rating_all_yes
    answers = { "q1" => "yes", "q2" => "yes", "q3" => "yes", "q4" => "yes", "q5" => "yes" }
    assert_equal 100.0, calculate_rating(answers)
  end

 
  def test_calculate_rating_mixed_answers
    answers = { "q1" => "yes", "q2" => "no", "q3" => "yes", "q4" => "no", "q5" => "yes" }
    assert_equal 60.0, calculate_rating(answers)
  end

 
  def test_calculate_rating_all_no
    answers = { "q1" => "no", "q2" => "no", "q3" => "no", "q4" => "no", "q5" => "no" }
    assert_equal 0.0, calculate_rating(answers)
  end

  def test_survey_loop_exit
    $stdin = StringIO.new("no\n")
    assert_raises(SystemExit) do
      loop do
        print "Do you want to run the survey again? (Yes/No): "
        choice = gets.chomp.downcase
        break unless ['yes', 'y'].include?(choice)
      end
    end
  ensure
    $stdin = STDIN
  end

 
  def test_survey_loop_continue
    $stdin = StringIO.new("yes\nno\n")
    output = capture_io do
      loop do
        print "Do you want to run the survey again? (Yes/No): "
        choice = gets.chomp.downcase
        break unless ['yes', 'y'].include?(choice)
      end
    end
    assert_match /Do you want to run the survey again/, output[0]
  ensure
    $stdin = STDIN
  end
end
