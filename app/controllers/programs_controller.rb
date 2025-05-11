class ProgramsController < ApplicationController
  before_action :set_program, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @programs = Program.includes(:topic, :subject)
                      .where(visible: true)
                      .order(created_at: :desc)
                      .page(params[:page])
                      .per(12)

    respond_to do |format|
      format.html
      format.json { render json: @programs }
    end
  end

  def show
    @program_comments = @program.program_comments.includes(:user)
                               .where(deleted: false)
                               .order(created_at: :desc)
                               .page(params[:page])
                               .per(10)

    respond_to do |format|
      format.html
      format.json { render json: @program }
    end
  end

  def new
    @program = Program.new
  end

  def create
    @program = Program.new(program_params)
    @program.user = current_user

    if @program.save
      redirect_to @program, notice: 'Program was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @program
  end

  def update
    authorize @program
    if @program.update(program_params)
      redirect_to @program, notice: 'Program was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @program
    @program.update(visible: false)
    redirect_to programs_path, notice: 'Program was successfully deleted.'
  end

  private

  def set_program
    @program = Program.find_by!(slug: params[:id])
  end

  def program_params
    params.require(:program).permit(
      :topic_id, :subject_id, :heading, :question, :solution,
      :difficulty_level, :estimated_duration, :description,
      :learning_objectives, :resources, :metadata
    )
  end
end 