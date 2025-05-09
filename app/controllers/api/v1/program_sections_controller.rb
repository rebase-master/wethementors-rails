module Api
  module V1
    class ProgramSectionsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_program
      before_action :set_section, only: [:show, :update, :destroy, :complete]
      before_action :authorize_admin, only: [:create, :update, :destroy]

      def index
        @sections = @program.program_sections.ordered.with_milestones
        render json: ProgramSectionSerializer.new(@sections).serializable_hash
      end

      def show
        render json: ProgramSectionSerializer.new(@section, include: [:milestones]).serializable_hash
      end

      def create
        @section = @program.program_sections.build(section_params)
        @section.order = ProgramSection.next_order(@program.id)

        if @section.save
          render json: ProgramSectionSerializer.new(@section).serializable_hash, status: :created
        else
          render json: { errors: @section.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @section.update(section_params)
          render json: ProgramSectionSerializer.new(@section).serializable_hash
        else
          render json: { errors: @section.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @section.destroy
        render json: { message: 'Section deleted successfully' }
      end

      def complete
        completion = @section.section_completions.find_or_initialize_by(user_id: current_user.id)
        completion.completed = true
        completion.completed_at = Time.current

        if completion.save
          render json: { message: 'Section marked as completed' }
        else
          render json: { errors: completion.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_program
        @program = Program.find(params[:program_id])
      end

      def set_section
        @section = @program.program_sections.find(params[:id])
      end

      def section_params
        params.require(:program_section).permit(
          :title, :description, :required, metadata: {}
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