class SearchController < ApplicationController
  def search
    @results = Search.query(params[:search_query], params[:search_type])
  end
end
