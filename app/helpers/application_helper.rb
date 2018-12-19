module ApplicationHelper
  def render_result(object)
    type = object.class.to_s.downcase
    render(partial: 'search/#{type}' )
  end
end
