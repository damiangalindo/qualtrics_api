module QualtricsApi
  class Configuration
    attr_accessor :version, :token, :endpoint, :organization, :default_library_id
    DEFAULT_VERSION = '3.0'
    DEFAULT_ENDPOINT = 'https://co1.qualtrics.com/API/v3'

    def initialize(&block)
      block.call(self) if block_given?
      self.version ||= DEFAULT_VERSION
      self.endpoint ||= DEFAULT_ENDPOINT
    end

    def update(&block)
      block.call(self) if block_given?
    end
  end
end
