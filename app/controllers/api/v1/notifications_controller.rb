module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_notification, only: [:show, :mark_as_read, :mark_as_unread, :destroy]

      def index
        @notifications = current_user.notifications
          .ordered
          .page(params[:page])
          .per(params[:per_page] || 20)

        render json: NotificationSerializer.new(@notifications).serializable_hash
      end

      def show
        render json: NotificationSerializer.new(@notification).serializable_hash
      end

      def mark_as_read
        @notification.mark_as_read!
        render json: NotificationSerializer.new(@notification).serializable_hash
      end

      def mark_as_unread
        @notification.mark_as_unread!
        render json: NotificationSerializer.new(@notification).serializable_hash
      end

      def mark_all_as_read
        current_user.notifications.mark_all_as_read!
        head :no_content
      end

      def mark_all_as_unread
        current_user.notifications.mark_all_as_unread!
        head :no_content
      end

      def destroy
        @notification.destroy
        head :no_content
      end

      def destroy_all
        current_user.notifications.destroy_all_for_recipient!
        head :no_content
      end

      private

      def set_notification
        @notification = current_user.notifications.find(params[:id])
      end
    end
  end
end 