class TopicsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index
    @topics = Topic.where(visible: true)
                  .order(:name)
                  .page(params[:page])
                  .per(20)

    respond_to do |format|
      format.html
      format.json { render json: @topics }
    end
  end

  def show
    @programs = @topic.programs
                     .where(visible: true)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(12)

    respond_to do |format|
      format.html
      format.json { render json: @topic }
    end
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)

    if @topic.save
      redirect_to @topic, notice: 'Topic was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @topic
  end

  def update
    authorize @topic
    if @topic.update(topic_params)
      redirect_to @topic, notice: 'Topic was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @topic
    @topic.update(visible: false)
    redirect_to topics_path, notice: 'Topic was successfully deleted.'
  end

  private

  def set_topic
    @topic = Topic.find_by!(url_name: params[:id])
  end

  def topic_params
    params.require(:topic).permit(:name, :url_name, :description)
  end
end 