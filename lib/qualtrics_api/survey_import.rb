module QualtricsApi
  class SurveyImport < Entity
    attr_accessor :survey_name, :survey, :survey_data_location, :survey_data_url

    def initialize(options={})
      @survey_name = options[:survey_name]
      @survey_data_location = options[:survey_data_location]
      @survey_data_url = options[:survey_data_url]
      @survey = QualtricsApi::Survey.new(survey_name: survey_name)
    end

    def save
      payload = {}
      payload['uploadSurvey'] = true
      payload['name'] = survey.survey_name
      payload['file'] = Faraday::UploadIO.new(survey_data_location, 'application/vnd.qualtrics.survey.txt') unless survey_data_location.blank?
      unless survey_data_url.blank?
        payload['contentType'] = content_type(survey_data_url)
        payload['fileUrl'] = survey_data_url
      end

      response = post('/surveys', payload)

      if response.success?
        survey.id = response.result['id']
        true
      else
        false
      end
    end

    private

    def content_type(fileUrl)
      case fileUrl.split('.').last
      when 'qsf'
        'application/vnd.qualtrics.survey.qsf'
      when 'txt'
        'application/vnd.qualtrics.survey.txt'
      when 'doc'
        'application/vnd.qualtrics.survey.doc'
      end
    end
  end
end
