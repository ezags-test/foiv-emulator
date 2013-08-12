class RequestsController < ApplicationController
  before_filter :build_resource
  respond_to :js, :only => :create

  def new
  end

  def create
    BirthRequest.begin_search params[:birth_filter].delete_if {|_, value| value == '' }
    render :nothing => true
  end

  private

  def build_resource
    @filter = BirthFilter.new(params[:birth_filter])
  end
end
