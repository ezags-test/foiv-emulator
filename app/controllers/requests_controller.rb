class RequestsController < ApplicationController
  def index
    @filter = BirthFilter.new(params[:birth_filter])
    render :index
  end
end
