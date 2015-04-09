require 'test_helper'
require_dependency 'fyber_offers_request'

class FyberOffersRequestTest < ActionController::TestCase

  def setup
    @request_attributes = { uid: 'player1', pub0: 'campaign2', page: 1 }
    @offers_request     = FyberOffersRequest.new(@request_attributes)
    @_payload            = {:appid=>157, :device_id=>"2b6f0cc904d137be2e1730235f5664094b831186", :locale=>"de", :ip=>"109.235.143.113",
                           :offer_types=>112, :uid=>"player1", :pub0=>"campaign2", :page=>1, :timestamp=>1428563049}
  end

  test '#api_offers_endpoint return right URL' do
    assert_equal @offers_request.send(:api_offers_endpoint), "http://api.sponsorpay.com/feed/v1/offers.json"
  end

  test '#payload_with_hashkey returns right hashkey' do
    assert_equal @offers_request.send(:hashkey, @_payload), 'd8f401fb7dc32d59e10fa1f29ce8af3209602842'
  end

end
