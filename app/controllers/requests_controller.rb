class RequestsController < ApplicationController
  before_filter :build_resource
  respond_to :js, :only => :create

  def new
  end

  def create
    ticket = BirthRequest.begin_search params[:birth_filter]
    render json: { ticket: ticket }
  end

  private

  def build_resource
    @filter = BirthFilter.new(params[:birth_filter])
  end
end
