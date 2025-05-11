class SubjectsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  def index
    @subjects = Subject.where(visible: true)
                      .order(:name)
                      .page(params[:page])
                      .per(20)

    respond_to do |format|
      format.html
      format.json { render json: @subjects }
    end
  end

  def show
    @topics = @subject.topics
                     .where(visible: true)
                     .order(:name)
                     .page(params[:page])
                     .per(12)

    respond_to do |format|
      format.html
      format.json { render json: @subject }
    end
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)

    if @subject.save
      redirect_to @subject, notice: 'Subject was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @subject
  end

  def update
    authorize @subject
    if @subject.update(subject_params)
      redirect_to @subject, notice: 'Subject was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @subject
    @subject.update(visible: false)
    redirect_to subjects_path, notice: 'Subject was successfully deleted.'
  end

  private

  def set_subject
    @subject = Subject.find_by!(url_name: params[:id])
  end

  def subject_params
    params.require(:subject).permit(:name, :url_name, :description)
  end
end 