class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show]

  def index
    @problems = Problem.all
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
      redirect_to problems_path
    else
      render :new
    end
  end

  private
  def set_problem
    @problem = Problem.find_by!(slug: params[:id])
  end

  def problem_params
    params.require(:problem).permit(:name, :description,
      relations_attributes: [:_destroy, :name, :problem_id,
      relation_attributes_attributes: [:_destroy, :name, :attr_type, :relation_id]])
  end
end
