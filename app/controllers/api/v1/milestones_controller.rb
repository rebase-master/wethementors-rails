module Api
  module V1
    class MilestonesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_program_section
      before_action :set_milestone, only: [:show, :update, :destroy, :complete]
      before_action :authorize_admin, only: [:create, :update, :destroy]

      def index
        @milestones = @program_section.milestones.ordered
        render json: MilestoneSerializer.new(@milestones).serializable_hash
      end

      def show
        render json: MilestoneSerializer.new(@milestone).serializable_hash
      end

      def create
        @milestone = @program_section.milestones.build(milestone_params)
        @milestone.order = Milestone.next_order(@program_section.id)

        if @milestone.save
          render json: MilestoneSerializer.new(@milestone).serializable_hash, status: :created
        else
          render json: { errors: @milestone.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @milestone.update(milestone_params)
          render json: MilestoneSerializer.new(@milestone).serializable_hash
        else
          render json: { errors: @milestone.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @milestone.destroy
        render json: { message: 'Milestone deleted successfully' }
      end

      def complete
        completion = @milestone.milestone_completions.find_or_initialize_by(user_id: current_user.id)
        completion.completed = true
        completion.completed_at = Time.current
        completion.submission_data = params[:submission_data] if params[:submission_data].present?

        if completion.save
          render json: { message: 'Milestone marked as completed' }
        else
          render json: { errors: completion.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_program_section
        @program_section = ProgramSection.find(params[:program_section_id])
      end

      def set_milestone
        @milestone = @program_section.milestones.find(params[:id])
      end

      def milestone_params
        params.require(:milestone).permit(
          :title, :description, :milestone_type, :estimated_duration,
          :required, :content, metadata: {}
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