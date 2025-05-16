module API
  module V1
    class Qa < Grape::API
      resource :qa do
        desc 'Add a question'
        params do
          requires :title, type: String, desc: 'Question title'
          requires :body, type: String, desc: 'Question body'
          optional :tags, type: Array[String], desc: 'Question tags'
        end
        post :add_question do
          # Ensure user is authenticated
          error!('Unauthorized', 401) unless current_user

          # Create the question
          question = Question.create(
            title: params[:title],
            body: params[:body],
            user_id: current_user.id
          )

          if question.persisted?
            # Add tags if provided
            if params[:tags].present?
              params[:tags].each do |tag_name|
                tag = Tag.find_or_create_by(name: tag_name)
                question.tags << tag unless question.tags.include?(tag)
              end
            end

            # Notify admin about the new question
            if Rails.env.production?
              UserMailer.notify_admin_new_question(
                current_user.full_name,
                question_url(question),
                question.user.email,
                question.user.full_name,
                question.body
              ).deliver_later
            end

            { 
              status: 'success', 
              message: 'Question added',
              question: {
                id: question.id,
                title: question.title,
                body: question.body,
                tags: question.tags.map { |tag| { id: tag.id, name: tag.name } }
              }
            }
          else
            error!('Failed to create question', 422)
          end
        end

        desc 'Remove a question'
        params do
          requires :question_id, type: Integer, desc: 'Question ID'
        end
        delete :remove_question do
          # Ensure user is authenticated
          error!('Unauthorized', 401) unless current_user

          # Find the question
          question = Question.find(params[:question_id])

          # Check if the user is the owner of the question
          error!('Forbidden', 403) unless question.user_id == current_user.id

          # Remove the question
          if question.destroy
            { status: 'success', message: 'Question removed' }
          else
            error!('Failed to remove question', 422)
          end
        end

        desc 'Add a comment to a question'
        params do
          requires :question_id, type: Integer, desc: 'Question ID'
          requires :comment, type: String, desc: 'Comment text'
        end
        post :add_comment do
          # Ensure user is authenticated
          error!('Unauthorized', 401) unless current_user

          # Find the question
          question = Question.find(params[:question_id])

          # Create the comment
          comment = Comment.create(
            question_id: params[:question_id],
            user_id: current_user.id,
            body: params[:comment]
          )

          if comment.persisted?
            # Send email notification if the commenter is not the question owner
            if current_user.id != question.user_id && Rails.env.production?
              UserMailer.notify_question_response(
                current_user.full_name,
                question_url(question),
                question.user.email,
                question.user.full_name,
                comment.body
              ).deliver_later
            end

            { 
              status: 'success', 
              message: 'Comment added',
              comment: {
                id: comment.id,
                username: current_user.username,
                time: 'a few seconds ago',
                avatar_url: current_user.avatar_url,
                body: comment.body
              }
            }
          else
            error!('Failed to create comment', 422)
          end
        end

        desc 'Remove a comment from a question'
        params do
          requires :comment_id, type: Integer, desc: 'Comment ID'
        end
        delete :remove_comment do
          # Ensure user is authenticated
          error!('Unauthorized', 401) unless current_user

          # Find the comment
          comment = Comment.find(params[:comment_id])

          # Check if the user is the owner of the comment
          error!('Forbidden', 403) unless comment.user_id == current_user.id

          # Remove the comment
          if comment.destroy
            { status: 'success', message: 'Comment removed' }
          else
            error!('Failed to remove comment', 422)
          end
        end

        desc 'Vote on a question'
        params do
          requires :question_id, type: Integer, desc: 'Question ID'
          requires :vote, type: Integer, desc: 'Vote value (1 or -1)'
        end
        post :question_vote do
          # Ensure user is authenticated
          error!('Unauthorized', 401) unless current_user

          # Find the question
          question = Question.find(params[:question_id])

          # Create or update the vote
          vote = QuestionVote.find_or_initialize_by(
            question_id: params[:question_id],
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

        desc 'Vote on a comment'
        params do
          requires :comment_id, type: Integer, desc: 'Comment ID'
          requires :vote, type: Integer, desc: 'Vote value (1 or -1)'
        end
        post :comment_vote do
          # Ensure user is authenticated
          error!('Unauthorized', 401) unless current_user

          # Find the comment
          comment = Comment.find(params[:comment_id])

          # Create or update the vote
          vote = CommentVote.find_or_initialize_by(
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

        desc 'Find tags'
        params do
          requires :query, type: String, desc: 'Search query for tags'
        end
        get :find_tags do
          # Search for tags matching the query
          tags = Tag.where('name LIKE ?', "%#{params[:query]}%")

          if tags.any?
            { status: 'success', tags: tags.map { |tag| { id: tag.id, name: tag.name } } }
          else
            { status: 'error', message: 'No tags found' }
          end
        end
      end
    end
  end
end 