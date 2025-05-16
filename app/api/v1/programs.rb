module API
  module V1
    class Programs < Grape::API
      resource :programs do
        desc 'Add a comment to a program'
        params do
          requires :program_id, type: Integer, desc: 'Program ID'
          requires :comment, type: String, desc: 'Comment text'
        end
        post :add_comment do
          # Ensure user is authenticated
          error!('Unauthorized', 401) unless current_user

          # Create comment using the ProgramComment model
          comment = ProgramComment.create(
            program_id: params[:program_id],
            user_id: current_user.id,
            comment: params[:comment]
          )

          if comment.persisted?
            { status: 'success', username: current_user.username, comment: comment.comment }
          else
            error!('Failed to create comment', 422)
          end
        end

        desc 'Remove a question from a program'
        params do
          requires :question_id, type: Integer, desc: 'Question ID'
        end
        delete :remove_question do
          # Ensure user is authenticated
          error!('Unauthorized', 401) unless current_user

          # Find the question
          question = ProgramQuestion.find(params[:question_id])

          # Check if the user is the owner of the question
          error!('Forbidden', 403) unless question.user_id == current_user.id

          # Remove the question
          if question.destroy
            { status: 'success', message: 'Question removed' }
          else
            error!('Failed to remove question', 422)
          end
        end

        desc 'Remove a comment from a program'
        params do
          requires :comment_id, type: Integer, desc: 'Comment ID'
        end
        delete :remove_comment do
          # Ensure user is authenticated
          error!('Unauthorized', 401) unless current_user

          # Find the comment
          comment = ProgramComment.find(params[:comment_id])

          # Check if the user is the owner of the comment
          error!('Forbidden', 403) unless comment.user_id == current_user.id

          # Remove the comment
          if comment.destroy
            { status: 'success', message: 'Comment removed' }
          else
            error!('Failed to remove comment', 422)
          end
        end

        desc 'Add a vote to a comment'
        params do
          requires :comment_id, type: Integer, desc: 'Comment ID'
          requires :vote, type: Integer, desc: 'Vote value (1 or -1)'
        end
        post :add_comment_vote do
          # Ensure user is authenticated
          error!('Unauthorized', 401) unless current_user

          # Find the comment
          comment = ProgramComment.find(params[:comment_id])

          # Create or update the vote
          vote = ProgramCommentVote.find_or_initialize_by(
            comment_id: params[:comment_id],
            user_id: current_user.id
          )

          # Update the vote value
          vote.value = params[:vote]

          if vote.save
            { status: 'success', message: 'Vote recorded' }
          else
            error!('Failed to record vote', 422)
          end
        end
      end
    end
  end
end 