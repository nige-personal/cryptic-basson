# frozen_string_literal: true

# struct for standardising person data
class PersonDto
  attr_accessor :id, :value, :first_name, :last_name, :country
  attr_accessor :latitude, :longitude, :company, :email, :address
end
