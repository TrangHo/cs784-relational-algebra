class ProblemsController < ApplicationController
  def new
    @problem = Problem.new
    @problem.relations.build
    @problem.test_cases.build
  end

  def create
  end
end
