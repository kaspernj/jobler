class JoblersController < Joblers::ApplicationController
  def show
    @jobler = Jobler::Jobler.find(params[:jobler_id])
  end
end
