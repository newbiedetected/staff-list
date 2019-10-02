class HomepageController < ApplicationController
  before_action :authenticate_employee!
  def index
    @employees = Employee.where(role: 'Employee').order(name: :asc).page(params[:page]).per(5)
    @questions = Question.where(view_to_list: 1)
    @answers = Answer.all
    respond_to do |format|
      format.js {render 'index.js.erb'}
      format.html
    end
  end

  def show
    @employee = Employee.find(params[:id])
    @answers = Answer.where(employee_id: params[:id])
    @questions = Question.all
  end

  def new
    flash[:errors] = ""
    @answer = Answer.new
    @question = Question.find(params[:id])
    @choices = Choice.all
    respond_to do |format|
      format.js {render 'add.js.erb'}
      format.html
    end
    flash[:success] = ""
  end

  def create
    @answer = Answer.new(set_params)
    if @answer.save
      @employee = Employee.find(current_employee.id)
      @questions = Question.all
      flash[:success] = "Answer Saved"
      respond_to do |format|
        format.js {render 'fresh.js.erb'}
        format.html
      end
    else
      flash[:errors] = @answer.errors.full_messages
      @employee = Employee.find(current_employee.id)
      @question = @answer.question
      respond_to do |format|
        format.js {render 'add.js.erb'}
        format.html
      end
    end
    flash[:success] = ""
    flash[:errors] = ""
  end

  def edit
    flash[:errors] = ""
    @employee = Employee.find(current_employee.id)
    @answer_edit = Answer.find(params[:id])
    @choices = Choice.all
    respond_to do |format|
      format.js {render 'edit.js.erb'}
      format.html
    end
    flash[:success] = ""
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update(update_params)
      flash[:success] = 'Answer updated successfully.'
      @employee = Employee.find(current_employee.id)
      @questions = Question.all
      respond_to do |format|
        format.js {render 'fresh.js.erb'}
        format.html
      end
    else
      flash[:errors] = @answer.errors.full_messages
      @employee = Employee.find(current_employee.id)
      @answer_edit = @answer
      respond_to do |format|
        format.js {render 'edit.js.erb'}
        format.html
      end
    end
    flash[:success] = ""
    flash[:errors] = ""
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    flash[:success] = 'Answer deleted successfully.'
    @employee = Employee.find(current_employee.id)
    @questions = Question.all
    respond_to do |format|
      format.js {render 'fresh.js.erb'}
      format.html
    end
    flash[:success] = ""
  end



  private
    def set_params
      params.require(:answer).permit(:answer, :question_id, :employee_id)
    end
    def update_params
      params.require(:answer).permit(:answer)
    end

end
