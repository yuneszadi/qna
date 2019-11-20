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

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end

end
