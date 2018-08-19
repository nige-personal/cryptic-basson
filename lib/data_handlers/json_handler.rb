# frozen_string_literal: true

#  class for loading json data
class JsonHandler
  DEFAULT_JSON_FILE_LOCATION = 'data/people.json'

  def get_person_dtos(sort)
    person_dtos = []
    data = load_json
    data.each do |person|
      person_dto = PersonDto.new
      person_dto.id = person['id']
      person_dto.first_name = person['name']['first']
      person_dto.last_name = person['name']['last']
      person_dto.value = person['value']
      person_dto.email = person['email']
      person_dto.latitude = person['location']['latitude']
      person_dto.longitude = person['location']['longitude']
      person_dto.country = person['country']
      person_dto.company = person['company']
      person_dto.address = person['address']

      person_dtos << person_dto
    end

    person_dtos = person_dtos.sort {|x, y| BigDecimal(x.value) <=> BigDecimal(y.value) }.reverse if sort
    person_dtos
  rescue DataUnavailableError => error
    raise error
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
