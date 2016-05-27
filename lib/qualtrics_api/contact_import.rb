module QualtricsApi
  class ContactImport < Entity
    attr_accessor :contacts, :mailing_list_id, :id, :filename
    validates :mailing_list_id, presence: true
    validates :contacts, presence: true
    # qualtrics_attribute :mailing_list_id, 'mailingListId'

    def initialize(options={})
      set_attributes(options) unless options[:contacts].blank?
      @mailing_list_id = options[:mailing_list_id]
      @id = options[:id]
    end

    def set_attributes(options={})
      @contacts = generate_json_file(options[:contacts])
    end

    def attributes
      { 
        'contacts' => contacts
      }.delete_if {|key, value| value.nil? }
    end

    def mailing_list=(mailing_list)
      self.mailing_list_id = mailing_list.id
    end

    def save
      return false if !valid?
      response = post("/mailinglists/#{mailing_list_id}/contactimports", attributes)

      File.delete(filename)

      if response.success?
        self.id = response.result['id']
        true
      else
        false
      end
    end

    def get_status
      response = get("/mailinglists/#{mailing_list_id}/contactimports/#{id}")
      if response.success? && response.result['percentComplete'] == 100
        'Contacts uploaded correctly.'
      else
        'Response is not ready yet.'
      end
    end

    # def update(options={})
    #   set_attributes(options)
    #   response = post('updateRecipient', update_params)

    #   if response.success?
    #     true
    #   else
    #     false
    #   end
    # end

    def self.attribute_map
      {
        'mailingListId'    => :mailing_list_id,
        'Email'            => :email,
        'FirstName'        => :first_name,
        'LastName'         => :last_name,
        'ExternalDataRef'  => :external_data,
        'Language'         => :language,
        'ED'               => :embedded_data,
        'Unsubscribed'     => :unsubscribed
      }
    end

    def generate_json_file(contacts)
      @filename = "./contacts_#{Time.now.to_i}.json"
      
      File.open(filename,"wb") do |file| 
        file.write contacts.to_json
      end

      Faraday::UploadIO.new(filename, 'application/json')
    end

    protected

    def update_params
      {
          'LibraryID' => library_id,
          'RecipientID' => id
      }.merge(attributes)
    end
  end
end
