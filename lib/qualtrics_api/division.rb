module QualtricsApi
  class Division < Entity
    attr_accessor :id, :name

    def initialize(options = {})
      @name = options[:name]
    end

    def save
      response = post('/divisions', {
        'name' => name
      })

      if response.success?
        self.id = response.result['id']
        true
      else
        false
      end
    end

    def update(options = {})
      response = put("/divisions/#{id}",
        options
      )

      if response.success?
        true
      else
        false
      end
    end
  end
end