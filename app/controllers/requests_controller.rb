class RequestsController < ApplicationController
  before_filter :build_resource

  def new
  end

  def create
  end

  private

  def build_resource
    @filter = BirthFilter.new(params[:birth_filter])
  end
end
