module Api
  module V1
    class ProgramCertificatesController < ApplicationController
      before_action :authenticate_user!, except: [:verify]
      before_action :set_program
      before_action :set_certificate, only: [:show, :revoke, :expire, :download]
      before_action :authorize_admin, only: [:revoke, :expire]

      def index
        @certificates = if current_user.admin?
          @program.program_certificates.includes(:user).recent
        else
          @program.program_certificates.where(user_id: current_user.id).includes(:user).recent
        end

        render json: ProgramCertificateSerializer.new(@certificates, include: [:user]).serializable_hash
      end

      def show
        render json: ProgramCertificateSerializer.new(@certificate, include: [:user]).serializable_hash
      end

      def create
        return render json: { error: 'Program not completed' }, status: :unprocessable_entity unless @program.completed_by?(current_user)
        return render json: { error: 'Certificate already exists' }, status: :unprocessable_entity if @program.program_certificates.exists?(user_id: current_user.id)

        @certificate = @program.program_certificates.build(
          user: current_user,
          achievement_data: generate_achievement_data
        )

        if @certificate.save
          render json: ProgramCertificateSerializer.new(@certificate).serializable_hash, status: :created
        else
          render json: { errors: @certificate.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def verify
        @certificate = ProgramCertificate.verify(params[:verification_code])
        
        if @certificate
          render json: ProgramCertificateSerializer.new(@certificate, include: [:user, :program]).serializable_hash
        else
          render json: { error: 'Invalid or expired certificate' }, status: :not_found
        end
      end

      def revoke
        if @certificate.revoke
          render json: ProgramCertificateSerializer.new(@certificate).serializable_hash
        else
          render json: { errors: @certificate.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def expire
        if @certificate.expire
          render json: ProgramCertificateSerializer.new(@certificate).serializable_hash
        else
          render json: { errors: @certificate.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def download
        # This will be implemented with a PDF generation service
        # For now, return the certificate data
        render json: @certificate.to_pdf
      end

      private

      def set_program
        @program = Program.find(params[:program_id])
      end

      def set_certificate
        @certificate = @program.program_certificates.find(params[:id])
      end

      def authorize_admin
        unless current_user.admin?
          render json: { error: 'Not authorized' }, status: :forbidden
        end
      end

      def generate_achievement_data
        enrollment = @program.enrollment_for(current_user)
        {
          completion_date: enrollment.completed_at,
          time_spent: enrollment.time_spent,
          final_score: enrollment.progress,
          milestones_completed: @program.program_sections.sum { |section| section.milestones.count { |m| m.completed_by?(current_user) } }
        }
      end
    end
  end
end 