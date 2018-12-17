class Search
  OBJECTS = %w(Users Questions Answers Comments)

   def self.results(search_text, search_object)
    query_escape = ThinkingSphinx::Query.escape(search_text)
    search_object.singularize.constantize.search query_escape
  end
end
