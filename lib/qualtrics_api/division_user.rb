module QualtricsApi
  class DivisionUser < Entity
    attr_accessor :id, :username, :password, :firstname, :lastname, :type, :division_id

    def initialize(options = {})
      @username = options[:username]
      @password = options[:password]
      @firstname = options[:firstname]
      @lastname = options[:lastname]
      @type = options[:type]
      @division_id = options[:division_id]
    end

    def save
      response = post('/users', {
        'username' => username,
        'password' => password,
        'firstName' => firstname,
        'lastName' => lastname,
        'userType' => type,
        'divisionId' => division_id,
        'language' => 'en'
      })

      if response.success?
        self.id = response.result['id']
        true
      else
        false
      end
    end

    def configuration
      Qualtrics.configuration
    end
  end
end