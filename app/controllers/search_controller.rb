class SearchController < ApplicationController
  def index
    search_text = params[:search_text]
    search_object = params[:search_object]
    @results = Search.results(search_text, search_object)
  end
end
