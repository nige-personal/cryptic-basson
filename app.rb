# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require 'haversine'
require 'bigdecimal'
require_relative 'lib/person_dto'
require_relative 'lib/data_handlers/person_json_repository'
require_relative 'lib/exceptions/data_unavailable_error'
require_relative 'lib/distance_calculator'
require_relative 'lib/calculate_request_model'

# Main entry point for routes
class App < Sinatra::Base
  
  #sanitise user input
  before do
    params.each do |p, v|
      params[p] = Rack::Utils.escape_html(v)
    end
  end
  
  # display all
  get '/' do
    # set defaults for bristol
    @calculate_request_model = CalculateRequestModel.new(lon: '-2.594678',
                                                         lat: '51.450167',
                                                         calcAvgValue: 'off')

    person_json_repository = PersonJsonRepository.new
    begin
      @people_stats = PersonDto.sort_by_value(person_json_repository.load())
    rescue DataUnavailableError => error
      halt 400, error.message
    end
    status 200
    erb :index
  end

  # filter and calculate average value depending on user input
  post '/' do
    @people_stats = {}

    @calculate_request_model = CalculateRequestModel.new(lon: params['lon'],
                                                         lat: params['lat'],
                                                         radius: params['radius'],
                                                         unit: params['unit'],
                                                         calcAvgValue: params['calcAvgValue'])

    person_json_repository = PersonJsonRepository.new
    begin
      person_dtos = person_json_repository.load()
      person_dtos = PersonDto.sort_by_value(person_dtos)
    rescue DataUnavailableError => error
      halt 400, error.message
    end

    @people_stats = persons_within_radius(person_dtos)

    @avg_value = PersonDto.calculate_average_value(@people_stats) if @calculate_request_model.calcAvgValue == 'on'
    status 200
    erb :index
  end

  private

  def persons_within_radius(person_dtos)
    people_stats = []

    person_dtos.each do |person_dto|
      if DistanceCalculator.within_radius?(@calculate_request_model, person_dto) == false
        next
      end

      people_stats << person_dto
    end
    people_stats
  end
end
