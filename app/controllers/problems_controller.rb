class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :test]

  def index
    @problems = Problem.approved
  end

  def show
  end

  def new
    @problem = Problem.new
    @problem.relations.build
    @problem.test_cases.build
  end

  def create
    @problem = Problem.new(problem_params)
    if @problem.save
      flash[:success] = "Your problem has been submitted and will be reviewed later."
      redirect_to problem_path(@problem.slug)
    else
      render :new
    end
  end

  def test
    debugger
  end

  private
  def set_problem
    @problem = Problem.find_by!(slug: params[:id])
  end

  def problem_params
    params.require(:problem).permit(:name, :description, :solution, :solution_json, 
      relations_attributes: [:id, :_destroy, :name, :problem_id,
      relation_attributes_attributes: [:id, :_destroy, :name, :attr_type, :relation_id]],
      test_cases_attributes: [:id, :_destroy, :name, :dataset, :problem_id])
  end
end
