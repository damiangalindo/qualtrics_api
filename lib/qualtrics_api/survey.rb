require 'zip'

module QualtricsApi
  class Survey < Entity
    attr_accessor :responses, :id, :survey_name,
                  :survey_owner_id, :survey_status, :survey_start_date,
                  :survey_expiration_date, :survey_creation_date,
                  :creator_id, :last_modified, :last_activated,
                  :status, :questions, :embedded_data, :responses_count

    @next_page = ''
    @survey_result = []

    def initialize(options={})
      @responses = options[:responses]
      @id = options[:id]
      @survey_name = options[:survey_name]
      @survey_owner_id = options[:survey_owner_id] || options[:owner_id]
      @survey_status = options[:is_active]
      @survey_start_date = options[:survey_start_date] || options[:start_date]
      @survey_expiration_date = options[:survey_expiration_date] || options[:expiration_date]
      @survey_creation_date = options[:survey_creation_date] || options[:creation_date]
      @creator_id = options[:creator_id] || options[:owner_id]
      @last_modified = options[:last_modified] || options[:last_modified_date]
      @last_activated = options[:last_activated]      
      @questions = options[:questions]
      @embedded_data = options[:embedded_data]
      @responses_count = options[:responses_count]
    end

    def self.paginated_response      
      get_surveys('/surveys')
    end

    def self.get_surveys(next_page)
      response = get(next_page)
      @survey_result = response.result['elements'].map do |survey|
        new(underscore_attributes(survey))
      end      
      @next_page = response.result['nextPage'] ? response.result['nextPage'].split('?')[1] : nil
      @survey_result
    end

    def self.next_page
      if @next_page
        get_surveys("/surveys?#{@next_page}")
      else
        []
      end
    end

    def self.find(survey_id)
      response = get("/surveys/#{survey_id}")
      new(underscore_attributes(response.result))
    end

    def generate_response_export(start_date, end_date, format = 'json', options = {})
      data = {
        'surveyId' => id,
        'startDate' => formatted_time(start_date),
        'endDate' => formatted_time(end_date),
        'format' => format
      }.merge(options)

      response = post('/responseexports', data)

      if response.status == 200
        response.result['id']
      else
        false
      end
    end    

    def retrieve_response_data(response_export_id)
      response = get_response_export(response_export_id)

      if !response.blank?
        get_file_content(response_export_id)
      else
        'Response is not ready yet.'
      end
    end

    def get_file_content(response_export_id)
      filename = "./response_data_#{response_export_id}.zip"
      binary_file = get_file("/responseexports/#{response_export_id}/file")

      json_response = []

      File.open(filename,"wb") do |file| 
        file.write binary_file
      end        

      json_response = Zip::File.open(filename) do |zip_file|
        zip_file.collect { |entry| JSON.parse(entry.get_input_stream.read) }
      end

      File.delete(filename)

      json_response[0]['responses']
    end

    def get_response_export(response_export_id)
      response = get("/responseexports/#{response_export_id}")

      if response.status == 200        
        response.result['file'] ? response.result['file'] : ''
      else
        false
      end
    end

    def self.attribute_map
      {
        'id' => :id,
        'name' => :survey_name,
        'ownerId' => :owner_id,
        'creationDate' => :creation_date,
        'lastModified' => :last_modified,
        'expiration' => :expiration,
        'lastModifiedDate' => :last_modified_date,
        'isActive' => :is_active,
        'embeddedData' => :embedded_data,
        'questions' => :questions,
        'responseCounts' => :responses_count
      }
    end

    def status
      @status = case survey_status
      when true
        'Active'
      when false
        'Inactive'
      else
        survey_status
      end
    end

    def destroy
      response = delete("/surveys/#{id}")
      response.success?
    end

    def activate
      response = put("/surveys/#{id}", {
        'isActive' => true
      })
      if response.success?
        @survey_status = true 
        true
      end
    end

    def deactivate
      response = put("/surveys/#{id}", {
        'isActive' => false
      })
      if response.success?
        @survey_status = false
        true
      end
    end

    def get_file(request)
      QualtricsApi::Operation.new(:get, request, nil).issue_file_request
    end
  end
end