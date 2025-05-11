class YearlyQuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = YearlyQuestion.includes(:subject)
                             .where(visible: true)
                             .order(year: :desc, created_at: :desc)
                             .page(params[:page])
                             .per(20)

    respond_to do |format|
      format.html
      format.json { render json: @questions }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @question }
    end
  end

  def new
    @question = YearlyQuestion.new
  end

  def create
    @question = YearlyQuestion.new(question_params)
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
    redirect_to yearly_questions_path, notice: 'Question was successfully deleted.'
  end

  private

  def set_question
    @question = YearlyQuestion.find_by!(slug: params[:id])
  end

  def question_params
    params.require(:yearly_question).permit(
      :year, :subject, :type, :question,
      :solution, :marks, :difficulty
    )
  end
end 