class Admin::ProblemsController < ProblemsController
  before_action :require_admin
  before_action :set_problem, only: [:show, :edit, :update, :destroy, :approve, :unapprove]

  def index
    @problems = Problem.all
  end

  def edit
    @problem = Problem.find_by(slug: params[:id])
    render "problems/edit"
  end

  def update
    @problem = Problem.find_by(slug: params[:id])
    if @problem.update_attributes(problem_params)
      flash[:success] = "Problem updated"
      redirect_to problem_path(@problem.slug)
    else
      render 'problems/edit'
    end
  end

  def destroy
    flash[:success] = "\"#{@problem.name}\" deleted"
    @problem.destroy
    redirect_to admin_problems_path
  end

  def approve
    if @problem.approve!
      flash[:success] = "\"#{@problem.name}\" approved"
    else
      flash[:error] = @problem.errors.full_messages
    end
    redirect_to admin_problems_path
  end

  def unapprove
    if @problem.unapprove!
      flash[:success] = "\"#{@problem.name}\" unapproved"
    else
      flash[:error] = @problem.errors.full_messages
    end
    redirect_to admin_problems_path
  end
end