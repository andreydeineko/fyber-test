class FyberOffersRequest
  DEFAULT_API_HEADERS  =  { accept: :json, content_type: :json }

  MANDATORY_ATTRIBUTES = [ :uid, :pub0, :page ]
  API_CONFIGURATION    = Rails.application.secrets[:fyber].symbolize_keys

  DEFAULT_API_PAYLOAD  =  API_CONFIGURATION.slice(:appid, :device_id, :locale, :ip, :offer_types)

  def initialize(attributes)
    raise ArgumentError, "One of mandatory attributes was not specified: #{mandatory_attributes_list}" unless mandatory_attributes_present?(attributes)

    # Mass assign attributes
    attributes.each do |key, value|
      instance_variable_set "@#{key}", value
    end

    @request = fyber_offers_request
  end

   def offers
    @offers ||= begin
                  response = execute
                  error_explained = 'The response X-Sponsorpay-Response-Signature header is not correct'
                  result = allow_response? ? response['offers'] : error_explained
                  result
                rescue Exception => exception
                  { error: exception.message }
                end
  end


  private

  def fyber_offers_request
    RestClient::Request.new(method: 'get', url: api_offers_endpoint, payload: payload_with_hashkey,
                            headers: DEFAULT_API_HEADERS)
  end

  def response_body
    @_response_body ||= @request.execute
  end

  def execute
    @_response ||= JSON.parse(response_body)
  end

  def api_offers_endpoint
    URI.join(API_CONFIGURATION[:api_host], "offers.#{API_CONFIGURATION[:format]}").to_s # => "http://api.sponsorpay.com/feed/v1/offers.json"
  end

  def payload_with_hashkey
    @_payload_with_hashkey ||= payload.merge(hashkey: hashkey(payload))
  end

  def payload
    @_payload ||= DEFAULT_API_PAYLOAD.merge(uid: @uid, pub0: @pub0, page: @page, timestamp: Time.now.to_i)
  end

  def hashkey(payload)
    Digest::SHA1.hexdigest(payload.except(:api_key).sort.map { |key, value| "#{key}=#{value}" }.join("&") + "&#{API_CONFIGURATION[:api_key]}")
  end

  def allow_response?
    response_body_with_api_key = response_body + API_CONFIGURATION[:api_key]
    @_header_hash = Digest::SHA1.hexdigest(response_body_with_api_key)
    @_allow = response_body.headers[:x_sponsorpay_response_signature] == @_header_hash
    @_allow
  end

  def mandatory_attributes_list
    MANDATORY_ATTRIBUTES.map { |attribute| ":#{attribute}" }.join ', '
  end

  def mandatory_attributes_present?(attributes)
    MANDATORY_ATTRIBUTES.all? { |attribute| attributes.include?(attribute.to_sym) }
  end
end
