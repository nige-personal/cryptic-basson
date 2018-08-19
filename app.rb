# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require 'pry-byebug'
require 'haversine'
require 'bigdecimal'
require_relative 'lib/person_dto'
require_relative 'lib/data_handlers/json_handler'
require_relative 'lib/exceptions/data_unavailable_error'

# Main entry point for routes
class App < Sinatra::Base
  get '/' do
    # set defaults for bristol
    @form_values = {params['calcAvgValue'] => 'off',
                     'lat' => '51.450167', 'lon' => '-2.594678'}

    json_handler = JsonHandler.new
    begin
      @people_stats = json_handler.get_person_dtos(true)
    rescue DataUnavailableError => error
      halt 400, error.message
    end
    status 200
    erb :index
  end

  post '/' do
    @people_stats = {}
    @form_values = {'lon'          => params['lon'],
                    'lat'          => params['lat'],
                    'radius'       => params['radius'],
                    'unit'         => params['unit'],
                    'calcAvgValue' => params['calcAvgValue']}

    json_handler = JsonHandler.new
    begin
      person_dtos = json_handler.get_person_dtos(true)
    rescue DataUnavailableError => error
      halt 400, error.message
    end

    @people_stats = sorted_data_within_radius(person_dtos, true)

    @avg_value = calculate_average_value(@people_stats) if params['calcAvgValue'] == 'on'
    status 200
    erb :index
  end

  private

  def within_radius?(lat, lon, radius, distance_unit, person)
    distance = Haversine.distance(BigDecimal(lat),
                                  BigDecimal(lon),
                                  BigDecimal(person.latitude),
                                  BigDecimal(person.longitude))

    case distance_unit
    when 'km'
      distance.to_kilometers <= radius.to_f
    when 'miles'
      distance.to_miles <= radius.to_f
    when 'feet'
      distance.to_feet <= radius.to_f
    when 'metres'
      distance.to_meters <= radius.to_f
    end
  end

  def sorted_data_within_radius(person_dtos, filter)
    people_stats = []

    person_dtos.each do |person_dto|
      if filter && within_radius?(params['lat'],
                                  params['lon'],
                                  params['radius'],
                                  params['unit'],
                                  person_dto) == false
        next
      end

      people_stats << person_dto
    end
    people_stats
  end

  def calculate_average_value(data)
    (data.map {|d| d.value.to_f }.reduce(:+) / data.size).round(2)
  end
end
