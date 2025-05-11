class QuizController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_category, only: [:show_category, :edit_category, :update_category, :destroy_category]
  before_action :set_question, only: [:show_question, :edit_question, :update_question, :destroy_question]

  def index
    @categories = QuizCategory.includes(:quiz_questions)
                            .where(active: true)
                            .order(:category)
                            .page(params[:page])
                            .per(12)

    respond_to do |format|
      format.html
      format.json { render json: @categories }
    end
  end

  def show_category
    @questions = @category.quiz_questions
                         .where(active: true)
                         .order(:difficulty)
                         .page(params[:page])
                         .per(10)

    respond_to do |format|
      format.html
      format.json { render json: @category }
    end
  end

  def new_category
    @category = QuizCategory.new
  end

  def create_category
    @category = QuizCategory.new(category_params)

    if @category.save
      redirect_to quiz_category_path(@category), notice: 'Category was successfully created.'
    else
      render :new_category, status: :unprocessable_entity
    end
  end

  def edit_category
    authorize @category
  end

  def update_category
    authorize @category
    if @category.update(category_params)
      redirect_to quiz_category_path(@category), notice: 'Category was successfully updated.'
    else
      render :edit_category, status: :unprocessable_entity
    end
  end

  def destroy_category
    authorize @category
    @category.update(active: false)
    redirect_to quiz_index_path, notice: 'Category was successfully deleted.'
  end

  def new_question
    @category = QuizCategory.find(params[:category_id])
    @question = QuizQuestion.new
  end

  def create_question
    @category = QuizCategory.find(params[:category_id])
    @question = @category.quiz_questions.build(question_params)

    if @question.save
      redirect_to quiz_category_path(@category), notice: 'Question was successfully created.'
    else
      render :new_question, status: :unprocessable_entity
    end
  end

  def show_question
    respond_to do |format|
      format.html
      format.json { render json: @question }
    end
  end

  def edit_question
    authorize @question
  end

  def update_question
    authorize @question
    if @question.update(question_params)
      redirect_to quiz_category_path(@question.quiz_category), notice: 'Question was successfully updated.'
    else
      render :edit_question, status: :unprocessable_entity
    end
  end

  def destroy_question
    authorize @question
    @question.update(active: false)
    redirect_to quiz_category_path(@question.quiz_category), notice: 'Question was successfully deleted.'
  end

  private

  def set_category
    @category = QuizCategory.find(params[:id])
  end

  def set_question
    @question = QuizQuestion.find(params[:question_id])
  end

  def category_params
    params.require(:quiz_category).permit(:category, :description)
  end

  def question_params
    params.require(:quiz_question).permit(
      :question, :correct_answer, :explanation,
      :difficulty, :options
    )
  end
end 