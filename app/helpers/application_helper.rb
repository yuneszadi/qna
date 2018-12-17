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
      if object.commentable_type == "Question"
        render(partial: 'search/question_comment', locals: { comment: object } )
      elsif object.commentable_type == "Answer"
        render(partial: 'search/answer_comment', locals: { comment: object } )
      end
    end
  end
end
