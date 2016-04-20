module QualtricsApi
  class Survey < Entity
    attr_accessor :responses, :id, :survey_name,
                  :survey_owner_id, :survey_status, :survey_start_date,
                  :survey_expiration_date, :survey_creation_date,
                  :creator_id, :last_modified, :last_activated,
                  :status, :questions, :embedded_data, :responses_count

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

    def self.all
      response = get('/surveys')
      response.result['elements'].map do |survey|
        new(underscore_attributes(survey))
      end
    end

    def self.find(survey_id)
      response = get("/surveys/#{survey_id}")
      new(underscore_attributes(response.result))
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
  end
end