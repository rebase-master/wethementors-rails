class QaController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :set_answer, only: [:edit_answer, :update_answer, :destroy_answer]

  def index
    @questions = QaQuestion.includes(:user)
                         .where(visible: true)
                         .order(created_at: :desc)
                         .page(params[:page])
                         .per(20)

    respond_to do |format|
      format.html
      format.json { render json: @questions }
    end
  end

  def show
    @answers = @question.qa_answers.includes(:user)
                        .where(visible: true)
                        .order(created_at: :desc)
                        .page(params[:page])
                        .per(10)

    respond_to do |format|
      format.html
      format.json { render json: @question }
    end
  end

  def new
    @question = QaQuestion.new
  end

  def create
    @question = QaQuestion.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Question was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @question
  end

  def update
    authorize @question
    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @question
    @question.update(visible: false)
    redirect_to qa_index_path, notice: 'Question was successfully deleted.'
  end

  def new_answer
    @question = QaQuestion.find(params[:question_id])
    @answer = QaAnswer.new
  end

  def create_answer
    @question = QaQuestion.find(params[:question_id])
    @answer = @question.qa_answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Answer was successfully created.'
    else
      render :new_answer, status: :unprocessable_entity
    end
  end

  def edit_answer
    authorize @answer
  end

  def update_answer
    authorize @answer
    if @answer.update(answer_params)
      redirect_to @answer.qa_question, notice: 'Answer was successfully updated.'
    else
      render :edit_answer, status: :unprocessable_entity
    end
  end

  def destroy_answer
    authorize @answer
    @answer.update(visible: false)
    redirect_to @answer.qa_question, notice: 'Answer was successfully deleted.'
  end

  private

  def set_question
    @question = QaQuestion.find(params[:id])
  end

  def set_answer
    @answer = QaAnswer.find(params[:answer_id])
  end

  def question_params
    params.require(:qa_question).permit(:title, :content, :topic)
  end

  def answer_params
    params.require(:qa_answer).permit(:content)
  end
end 