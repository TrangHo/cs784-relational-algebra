class Admin::TestCasesController < ProblemsController
  before_action :require_admin

  def destroy
    @test_case = TestCase.find(params[:id])
    problem = @test_case.problem
    @test_case.destroy
    flash[:success] = "Test case deleted"
    redirect_to edit_admin_problem_path(problem)
  end

end
