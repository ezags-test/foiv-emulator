# encoding: utf-8
class AutocompleteController < ApplicationController
  def select_registrar
    render json: HTTParty.get()
  end

  def select_nationality
    render json: Nationality.autocomplete_search(params[:query], gender: params[:gender])
  end

  def select_citizenship
    render json: Citizenship.autocomplete_search(params[:query], gender: params[:gender])
  end
end
