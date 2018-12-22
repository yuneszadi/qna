class Search < ApplicationRecord
  OBJECTS = %w[Question Answer Comment User]

  def self.execute(query, category = nil)
    if OBJECTS.include?(category)
      model = category.classify.constantize
      model.search query
    else
      ThinkingSphinx.search query
    end
  end
end
