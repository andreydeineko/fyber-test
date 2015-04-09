require_dependency 'fyber_offers_request'

class OffersController < ApplicationController
  def index
  end

  def create
    @offers = FyberOffersRequest.new(offers_request_params).offers

    if @offers.is_a?(Hash) and @offers[:error].present?
      render json: { error: @offers[:error] }, status: 422
    elsif @offers == 'The response X-Sponsorpay-Response-Signature header is not correct'
      render json: { error: @offers }, status: 422
    else
      render json: { offers: render_to_string(partial: 'offer', collection: @offers) }, status: 200
    end
  end

  private

  def offers_request_params
    params.require(:offer).permit(:uid, :pub0, :page)
  end
end
