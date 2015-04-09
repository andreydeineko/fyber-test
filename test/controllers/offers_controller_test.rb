require 'test_helper'
require_dependency 'fyber_offers_request'

class OffersControllerTest < ActionController::TestCase
  def setup
    @request_attributes = { uid: 'player1', pub0: 'campaign2', page: 1 }
    @offers_request     = FyberOffersRequest.new(@request_attributes)
    @response_json      = File.read File.join(Rails.root, 'test/fixtures/offers.json')
  end

  test "#create assigns @offers when valid params submitted but checks for header signature" do
    @response_json = File.read File.join(Rails.root, 'test/fixtures/incorrect_header.json')
    stub = stub_request(:get, @offers_request.send(:api_offers_endpoint)).to_return(status: 200, body: @response_json, headers: {})
      with_temp_stub(stub) do
        post :create, offer: @request_attributes
        assert_response 422
        assert_equal 'The response X-Sponsorpay-Response-Signature header is not correct', assigns(:offers)
      end
  end

  test "#create assigns error message to @offers in case of invalid parameters" do
    stub = stub_request(:get, @offers_request.send(:api_offers_endpoint)).to_return(status: 400)

    with_temp_stub(stub) do
      post :create, offer: @request_attributes
      assert_response 422
      assert_equal({"error"=>"400 Bad Request"}, JSON.parse(response.body))
    end
  end

  private

  def with_temp_stub(stub)
    begin
      yield
    ensure
      remove_request_stub(stub)
    end
  end
end

