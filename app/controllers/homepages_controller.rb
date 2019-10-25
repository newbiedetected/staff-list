class HomepagesController < ApplicationController
  before_action :authenticate_employee!
  def index
    @q = Employee.ransack(params[:q])
    @employees = @q.result.order(name: :asc).page(params[:page]).per(15)
    @questions = Question.where(view_to_list: 1)
    @answers = Answer.all
    respond_to do |format|
      format.js {render 'index.js.erb'}
      format.html
    end
  end

  def show
    @employee_detail = current_employee
    @employee = Employee.find(params[:id])
    @answers = Answer.where(employee_id: params[:id])
    @questions = Question.all
    @answered = @answers.count
    @unanswered = @questions.count - @answered
  end

  def new
    @answer = Answer.new
    @question = Question.find(params[:id])
    @choices = Choice.all
    respond_to do |format|
      format.js {render 'add.js.erb'}
      format.html
    end
  end

  def create
    @answer = Answer.new(set_params)
    if @answer.save
      @employee = Employee.find(current_employee.id)
      @answers = Answer.where(employee_id: current_employee.id)
      @questions = Question.all
      @answered = @answers.count
      @unanswered = @questions.count - @answered
      flash.now[:success] = "Answer Saved"
      respond_to do |format|
        format.js {render 'fresh.js.erb'}
        format.html
      end
    else
      flash.now[:errors] = @answer.errors.full_messages
      @employee = Employee.find(current_employee.id)
      @question = @answer.question
      respond_to do |format|
        format.js {render 'add.js.erb'}
        format.html
      end
    end
  end

  def edit
    @employee = Employee.find(current_employee.id)
    @answer_edit = Answer.find(params[:id])
    @choices = Choice.all
    respond_to do |format|
      format.js {render 'edit.js.erb'}
      format.html
    end
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update(update_params)
      flash.now[:success] = 'Answer updated successfully.'
      @employee = Employee.find(current_employee.id)
      @questions = Question.all
      respond_to do |format|
        format.js {render 'fresh.js.erb'}
        format.html
      end
    else
      flash.now[:errors] = @answer.errors.full_messages
      @employee = Employee.find(current_employee.id)
      @answer_edit = @answer
      respond_to do |format|
        format.js {render 'edit.js.erb'}
        format.html
      end
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    flash.now[:success] = 'Answer deleted successfully.'
    @employee = Employee.find(current_employee.id)
    @answers = Answer.where(employee_id: current_employee.id)
    @questions = Question.all
    @answered = @answers.count
    @unanswered = @questions.count - @answered
    respond_to do |format|
      format.js {render 'fresh.js.erb'}
      format.html
    end
  end

  def answer
    @employee = Employee.find(params[:id])
    @questions = Question.where(view_to_list: 1)
    @answers = Answer.all
    respond_to do |format|
      format.js {render 'answer.js.erb'}
      format.html
    end
  end

  def view_question_in_list
    @question = Question.find(params[:id])
    @answers = Answer.where(question_id: @question.id)
    respond_to do |format|
      format.js {render 'question.js.erb'}
      format.html
    end
  end

  def close
    @questions = Question.where(view_to_list: 1)
    respond_to do |format|
      format.js {render 'close.js.erb'}
      format.html
    end
  end

  def update_password
    @employee_detail = current_employee
    if @employee_detail.update_with_password(user_params)
      bypass_sign_in(@employee_detail)
      flash[:success] = 'Password changed!'
      render js: "window.location='#{homepage_path(current_employee.id)}'"
    else
      flash.now[:errors] = @employee_detail.errors.full_messages
      respond_to do |format|
        format.js {render 'random.js.erb'}
        format.html
      end
    end
  end


  



  private
    def set_params
      params.require(:answer).permit(:answer, :question_id, :employee_id)
    end
    def update_params
      params.require(:answer).permit(:answer)
    end

    def user_params
    # NOTE: Using `strong_parameters` gem
      params.require(:employee).permit(:current_password, :password, :password_confirmation)
    end

end
