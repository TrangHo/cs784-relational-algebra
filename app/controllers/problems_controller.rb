class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show]
  before_action :logged_in_admin, only: [:edit, :update]

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
      redirect_to problem_path(@problem.slug)
    else
      render :new
    end
  end

  def edit
    @problem = Problem.find_by(slug: params[:id])
  end

  def update
    @problem = Problem.find_by(slug: params[:id])
    if @problem.update_attributes(problem_params)
      flash[:success] = "Problem updated"
      redirect_to problem_path(@problem.slug)
    else
      render 'edit'
    end
  end

  private
  def set_problem
    @problem = Problem.find_by!(slug: params[:id])
  end

  # Confirms a logged-in admin.
  def logged_in_admin
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def problem_params
    params.require(:problem).permit(:name, :description,
      relations_attributes: [:id, :_destroy, :name, :problem_id,
      relation_attributes_attributes: [:id, :_destroy, :name, :attr_type, :relation_id]])
  end
end
