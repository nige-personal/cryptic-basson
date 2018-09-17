# frozen_string_literal: true

require 'spec_helper'

describe App do
  include Rack::Test::Methods
  let(:app) { App.new }

  describe 'GET to /' do
    let(:response) { get '/' }

    context 'when data loads ok' do
      it 'returns status 200 OK' do
        expect(response.status).to eq 200
      end

      it 'displays a list of people related data' do
        expect(response.body).to include(
          '5a00487936eb5ad19bcd5fc9',
          'Melanie Buckner',
          '3320.72',
          'melanie.buckner@fleetmix.co.uk'
        )
      end
    end
    context 'when data cannot be loaded' do
      it 'returns status 200 OK' do
        allow(ENV).to receive(:fetch)
          .with('JSON_FILE_LOCATION',
                JsonHandler::DEFAULT_JSON_FILE_LOCATION).and_return 'myfile/location'
        expect(response.status).to eq 400
      end
    end
  end

  describe 'POST to /' do
    let(:params) { {lat: '51.450167', lon: '-2.594678', radius: '50', unit: 'km', calcAvgValue: 'on'} }
    let(:response) { post '/', params }

    context 'when form values are present' do
      context 'when calculate average value is requested' do
        it 'returns status 200 OK' do
          expect(response.status).to eq 200
        end

        it 'displays the correct average value' do
          expect(response.body).to include(
            'Average Value: 2750.27'
          )
        end
      end
      context 'when calculate average value is NOT requested' do
        let(:params) { {lat: '51.450167', lon: '-2.594678', radius: '50', unit: 'km', calcAvgValue: 'off'} }
        it 'does NOT display the average value' do
          expect(response.body).to_not include(
            'Average Value:'
          )
        end
      end
    end
  end
end
