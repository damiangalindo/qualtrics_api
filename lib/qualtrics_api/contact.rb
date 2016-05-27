module QualtricsApi
  class Contact < Entity
    attr_accessor :email, :first_name, :last_name, :external_data, :embedded_data, :unsubscribed, :id, :mailing_list_id, :response_history
    validates :mailing_list_id, presence: true
    # qualtrics_attribute :mailing_list_id, 'mailingListId'

    def initialize(options={})
      @id = options[:id]
      @mailing_list_id = options[:mailing_list_id]
      @email = options[:email]
      @first_name = options[:first_name]
      @last_name = options[:last_name]
      @external_data = options[:external_data]
      @embedded_data = options[:embedded_data]
      @unsubscribed = options[:unsubscribed]
      @response_history = options[:response_history]
    end

    def self.all(mailing_list_id = nil)
      mailing_list_id = mailing_list_id
      response = get("/mailinglists/#{mailing_list_id}/contacts")

      if response.success?
        response.result['elements'].map do |element|
          new(underscore_attributes(element))
        end
      else
        []
      end
    end

    def self.find(mailing_list_id, id)
      response = get("/mailinglists/#{mailing_list_id}/contacts/#{id}")

      if response.success?
        new(underscore_attributes(response.result))
      else
        false
      end
    end

    def delete
      response = delete("/mailinglists/#{mailing_list_id}/contacts/#{:id}")

      if response.success?
        true
      else
        false
      end
    end    

    def save
      contact_info = [{
        "id": id,
        "firstName": first_name,
        "lastName": last_name,
        "email": email,
        "language": "EN",
        "unsubscribed":1
      }]

      QualtricsApi::ContactImport.new({mailing_list_id: mailing_list_id, contacts: contact_info}).save
    end

    def self.attribute_map
      {
        'id'                     => :id,
        'email'                  => :email,
        'firstName'              => :first_name,
        'lastName'               => :last_name,
        'externalDataReference'  => :external_data,
        'responseHistory'        => :response_history,
        'embeddedData'           => :embedded_data,
        'unsubscribed'           => :unsubscribed
      }
    end

    def configuration
      QualtricsApi.configuration
    end
  end
end