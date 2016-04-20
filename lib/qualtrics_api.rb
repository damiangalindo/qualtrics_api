require 'configatron'

require "qualtrics_api/configuration"
require "qualtrics_api/version"
require "qualtrics_api/operation"
require "qualtrics_api/response"
require "qualtrics_api/entity"
require "qualtrics_api/survey"
require "qualtrics_api/survey_import"
require "qualtrics_api/division"
require "qualtrics_api/division_user"

module QualtricsApi
  def self.configure(&block)
    configuration.update(&block)
  end

  def self.configuration
    if !configatron.has_key?(:qualtrics_api)
      configatron.qualtrics_api = Configuration.new
    end
    configatron.qualtrics_api
  end

  class Error < StandardError; end
  class ServerErrorEncountered < Error; end
  class UpdateNotAllowed < Error; end
  class UnexpectedRequestMethod < Error; end
  class UnexpectedContentType < Error; end
end
