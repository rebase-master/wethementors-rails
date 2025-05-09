module Api
  module V1
    class TagsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_tag, only: [:show, :update, :destroy]

      def index
        @tags = Tag.ordered.page(params[:page])
        render json: TagSerializer.new(@tags).serializable_hash
      end

      def show
        render json: TagSerializer.new(@tag).serializable_hash
      end

      def create
        @tag = Tag.new(tag_params)
        
        if @tag.save
          render json: TagSerializer.new(@tag).serializable_hash, status: :created
        else
          render json: { errors: @tag.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @tag.update(tag_params)
          render json: TagSerializer.new(@tag).serializable_hash
        else
          render json: { errors: @tag.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if @tag.destroy
          head :no_content
        else
          render json: { errors: @tag.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_tag
        @tag = if params[:name]
          Tag.find_by_name(params[:name])
        else
          Tag.find(params[:id])
        end
      end

      def tag_params
        params.require(:tag).permit(:name)
      end
    end
  end
end 