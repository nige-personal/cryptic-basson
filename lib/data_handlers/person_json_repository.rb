# frozen_string_literal: true

#  class for loading json data
class PersonJsonRepository
  DEFAULT_JSON_FILE_LOCATION = 'data/people.json'

  def load()
    person_dtos = []
    data = load_json
    data.each do |person|
      person_dto = PersonDto.new(id: person['id'],
                                 first_name: person['name']['first'],
                                 last_name: person['name']['last'],
                                 value: person['value'],
                                 email: person['email'],
                                 latitude: person['location']['latitude'],
                                 longitude: person['location']['longitude'],
                                 country: person['country'],
                                 company: person['company'],
                                 address: person['address']
      )

      person_dtos << person_dto
    end
    person_dtos
  end

  private

  def load_json
    file_location = ENV.fetch('JSON_FILE_LOCATION', DEFAULT_JSON_FILE_LOCATION)
    begin
      file = File.read(file_location)
      JSON.parse(file)
    rescue Errno::ENOENT
      raise DataUnavailableError.new('Error: Data could not be loaded, file not found')
    end
  end
end
