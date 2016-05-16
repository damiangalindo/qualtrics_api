require 'faraday'
require 'faraday_middleware'

module QualtricsApi
  class Operation
    attr_reader :http_method, :action, :options
    REQUEST_METHOD_WHITELIST = [:get, :post, :delete, :put]
    @@listeners = []

    def initialize(http_method, action, options, body_override = nil)
      @http_method = http_method
      @action = action
      @options = options
      @body_override = body_override
    end

    def issue_request
      raise Qualtrics::UnexpectedRequestMethod if !REQUEST_METHOD_WHITELIST.include?(http_method)

      query = options
      body = nil
      query_params = {}
      raw_resp = nil

      if @body_override
        body = @body_override
        query_params = query
        raw_resp = connection.send(http_method, "/API/v3#{action}", body) do |req|
          req.params = query_params
        end
      else
        body = query
        upload_survey = body.delete('uploadSurvey')

        raw_resp = connection.send(http_method, "/API/v3#{action}", body) do |req|
          req.headers['Content-Type'] = 'multipart/form-data' if upload_survey
        end        
      end

      QualtricsApi::Response.new(raw_resp).tap do |response|
        if !@listeners_disabled
          @@listeners.each do |listener|
            listener.received_response(self, response)
          end
        end
      end
    end

    def issue_file_request
      raise Qualtrics::UnexpectedRequestMethod if !REQUEST_METHOD_WHITELIST.include?(http_method)

      query = options
      body = nil
      query_params = {}
      raw_resp = nil      
      raw_resp = connection.send(http_method, "/API/v3#{action}", query)

      raw_resp.body
    end

    def disable_listeners(&block)
      @listeners_disabled = true
      block.call(self)
      @listeners_disabled = nil
    end

    class << self
      def add_listener(listener)
        @@listeners << listener
      end

      def delete_listener(listener)
        @@listeners.delete(listener)
      end

      def flush_listeners!
        @@listeners = []
      end
    end

    protected

    def connection
      @connection ||= Faraday.new(:url => 'https://co1.qualtrics.com') do |faraday|
        faraday.request  :multipart
        faraday.request  :json
        faraday.request  :url_encoded
        faraday.use ::FaradayMiddleware::FollowRedirects, limit: 3
        faraday.adapter Faraday.default_adapter
        faraday.headers['X-API-TOKEN'] = configuration.token
      end
    end

    def configuration
      QualtricsApi.configuration
    end
  end
end