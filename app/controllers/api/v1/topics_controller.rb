module Api
  module V1
    class TopicsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_topic, only: [:show, :update, :destroy]

      def index
        @topics = Topic.visible.ordered.page(params[:page])
        render json: TopicSerializer.new(@topics).serializable_hash
      end

      def show
        render json: TopicSerializer.new(@topic).serializable_hash
      end

      def create
        @topic = Topic.new(topic_params)
        
        if @topic.save
          render json: TopicSerializer.new(@topic).serializable_hash, status: :created
        else
          render json: { errors: @topic.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @topic.update(topic_params)
          render json: TopicSerializer.new(@topic).serializable_hash
        else
          render json: { errors: @topic.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if @topic.destroy
          head :no_content
        else
          render json: { errors: @topic.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_topic
        @topic = if params[:url_name]
          Topic.find_by_url_name(params[:url_name])
        else
          Topic.find(params[:id])
        end
      end

      def topic_params
        params.require(:topic).permit(:name, :url_name, :visible)
      end
    end
  end
end 