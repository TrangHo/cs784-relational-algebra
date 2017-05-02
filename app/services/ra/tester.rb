module RA
  class Tester
    include Constant
    include Concerns::PredicateUtility

    def initialize(problem)
      @base_ra_exp = RA::Base.parse(problem.solution_json)
      @problem = problem
    end

    def test(user_ra_exp_json)
      user_ra_exp = RA::Base.parse(user_ra_exp_json)
      result = []
      @problem.test_cases.each do |test_case|
        base_ra_result = @base_ra_exp.apply_to(test_case.dataset)
        user_ra_result = user_ra_exp.apply_to(test_case.dataset)
        correct = base_ra_result.size == user_ra_result.size && (base_ra_result - user_ra_result).empty? && (user_ra_result - base_ra_result).empty?
        result << {
          test_case_id: test_case.id,
          dataset: test_case.dataset,
          base_ra_result: base_ra_result,
          user_ra_result: user_ra_result,
          correct: correct
        }
      end
      result
    end
  end
end
