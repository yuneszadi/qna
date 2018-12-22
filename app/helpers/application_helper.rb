module ApplicationHelper
  def render_result(object)
    type = object.class.to_s
    case type
      when "Question"
        render(partial: 'search/question', locals: { question: object } )
      when "Answer"
        render(partial: 'search/answer', locals: { answer: object } )
      when "User"
        render(partial: 'search/user', locals: { user: object } )
      when "Comment"
        partial = object.commentable_type == 'Question' ? 'search/question_comment' : 'search/answer_comment'
        render(partial: partial, locals: { comment: object } )
    end
  end
end
