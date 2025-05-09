module Api
  module V1
    class ProgramsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show, :show_by_slug]
      before_action :set_program, only: [:show, :update, :destroy, :enroll, :unenroll, :progress]
      before_action :authorize_admin, only: [:create, :update, :destroy]

      def index
        @programs = Program.visible
          .includes(:topic, :tags)
          .by_difficulty(params[:difficulty])
          .by_duration(params[:max_duration])
          .with_prerequisites

        if params[:topic_id].present?
          @programs = @programs.by_topic(params[:topic_id])
        end

        if params[:tag].present?
          @programs = @programs.joins(:tags).where(tags: { name: params[:tag] })
        end

        render json: ProgramSerializer.new(@programs).serializable_hash
      end

      def show
        render json: ProgramSerializer.new(@program, include: [:topic, :tags, :prerequisite_programs]).serializable_hash
      end

      def show_by_slug
        @program = Program.find_by_slug(params[:slug])
        render json: ProgramSerializer.new(@program, include: [:topic, :tags, :prerequisite_programs]).serializable_hash
      end

      def create
        @program = Program.new(program_params)
        if @program.save
          render json: ProgramSerializer.new(@program).serializable_hash, status: :created
        else
          render json: { errors: @program.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @program.update(program_params)
          render json: ProgramSerializer.new(@program).serializable_hash
        else
          render json: { errors: @program.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @program.destroy
        render json: { message: 'Program deleted successfully' }
      end

      def enroll
        if @program.enroll(current_user)
          render json: { message: 'Successfully enrolled in program' }
        else
          render json: { error: 'Unable to enroll in program' }, status: :unprocessable_entity
        end
      end

      def unenroll
        enrollment = @program.enrollment_for(current_user)
        if enrollment&.drop
          render json: { message: 'Successfully unenrolled from program' }
        else
          render json: { error: 'Unable to unenroll from program' }, status: :unprocessable_entity
        end
      end

      def progress
        enrollment = @program.enrollment_for(current_user)
        if enrollment
          render json: ProgramEnrollmentSerializer.new(enrollment).serializable_hash
        else
          render json: { error: 'Not enrolled in this program' }, status: :not_found
        end
      end

      def related
        @program = Program.find(params[:id])
        @related = Program.related_programs(@program.topic_id)
        render json: ProgramSerializer.new(@related).serializable_hash
      end

      private

      def set_program
        @program = Program.find(params[:id])
      end

      def program_params
        params.require(:program).permit(
          :question, :solution, :topic_id, :difficulty_level,
          :estimated_duration, :description, :learning_objectives,
          :visible, resources: {}, metadata: {},
          prerequisite_program_ids: [], tag_ids: []
        )
      end

      def authorize_admin
        unless current_user.admin?
          render json: { error: 'Unauthorized' }, status: :forbidden
        end
      end
    end
  end
end 