require 'faraday'
require 'faraday_middleware'
require 'json'

module QualtricsApi
  class MailingList < Entity
    attr_accessor :id, :name, :library_id

    # def self.all(library_id = nil)
    #   lib_id = library_id || configuration.default_library_id
    #   response = get('getPanels', {'LibraryID' => lib_id})
    #   if response.success?
    #     response.result['Panels'].map do |panel|
    #       new(underscore_attributes(panel))
    #     end
    #   else
    #     []
    #   end
    # end

    def self.attribute_map
      {
        'libraryId' => :library_id,
        'name' => :name,
        'id' => :id
      }
    end

    def initialize(options={})
      @name = options[:name]
      @id = options[:id]
      @library_id = options[:library_id] || configuration.default_library_id
    end

    def save
      response = nil
      if persisted?
        raise QualtricsApi::UpdateNotAllowed
      else
        response = post('/mailinglists', attributes)
      end

      if response.success?
        self.id = response.result['id']
        true
      else
        false
      end
    end

    def configuration
      QualtricsApi.configuration
    end

    # def add_recipients(recipients)
    #   panel_import = QualtricsApi::ContactImport.new({
    #       panel: self,
    #       recipients: recipients
    #   })
    #   panel_import.save
    # end

    def destroy
      response = delete("/mailinglists/#{self.id}")
      response.success?
    end

    def attributes
      {
        'libraryId' => library_id,
        'name' => name
      }
    end
  end
end
