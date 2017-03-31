class ProblemsController < ApplicationController
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
  def problem_params
    params.require(:problem).permit(:name, :description,
      relations_attributes: [:_destroy, :name, :problem_id,
      relation_attributes_attributes: [:_destroy, :name, :attr_typem, :relation_id]])
  end
end
