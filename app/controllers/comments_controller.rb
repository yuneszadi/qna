class CommentsController < ActionController::Base
  before_action :authenticate_user!
  before_action :find_resource, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def find_resource
    return @resource = Answer.find(params[:answer_id]) if params[:answer_id]
    @resource = Question.find(params[:question_id]) if params[:question_id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    question_id = @resource.is_a?(Question) ? @resource.id : @resource.question.id
    ActionCable.server.broadcast("comments_question_#{question_id}", comment: @comment)
  end
end
