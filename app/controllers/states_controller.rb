class StatesController < ApplicationController
  respond_to :xml, :json
  layout false

  def index
    @states = params[:country_id].present? ? State.all_with_country_id(params[:country_id]) : State.all
  end
end
