# frozen_string_literal: true

# struct for standardising person data
class PersonDto
  attr_accessor :id, :value, :first_name, :last_name, :country
  attr_accessor :latitude, :longitude, :company, :email, :address

  def initialize(id:, first_name:, last_name:, country:, latitude:, longitude:, company:, email:, address:, value:)
    @id = id
    @first_name = first_name
    @last_name = last_name
    @country = country
    @latitude = latitude
    @longitude = longitude
    @company = company
    @email = email
    @address = address
    @value = value
  end


  def self.sort_by_value(person_dtos, asc=true)
    if(asc)
      person_dtos = person_dtos.sort {|x, y| BigDecimal(x.value) <=> BigDecimal(y.value) }
    else
      person_dtos = person_dtos.sort {|x, y| BigDecimal(y.value) <=> BigDecimal(x.value) }
    end
    person_dtos
  end

  def self.calculate_average_value(person_dtos)
    person_dtos.size > 0 ? (person_dtos.map {|d| d.value.to_f }.reduce(:+) / person_dtos.size).round(2) : 0
  end
end
