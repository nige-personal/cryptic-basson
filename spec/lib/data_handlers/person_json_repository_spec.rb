# frozen_string_literal: true

RSpec.describe PersonJsonRepository do
  describe '#get_person_dtos' do
    context 'when the data file loads correctly' do
      it 'expects the correct number of person_dtos' do
        expect(subject.load().size).to eq 100
      end

      it 'expects the person_dtos to be sorted descending' do
        person_dtos = PersonDto.sort_by_value(subject.load(), false)
        expect(person_dtos.first.value).to be > person_dtos[1].value
        expect(person_dtos[98].value).to be > person_dtos[99].value
      end

      it 'expects the person_dtos to not be sorted' do
        person_dtos = subject.load()
        expect(person_dtos.first.value).to be < person_dtos[1].value
      end
    end
    context 'when the data file does NOT load correctly' do
      it 'expects an error to be raised' do
        allow(ENV).to receive(:fetch)
          .with('JSON_FILE_LOCATION',
            PersonJsonRepository::DEFAULT_JSON_FILE_LOCATION)
          .and_return 'myfile/location'
        expect { PersonDto.sort_by_value(subject.load()) }.to raise_error(DataUnavailableError)
      end
    end
  end
end
