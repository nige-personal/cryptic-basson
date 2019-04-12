class DistanceCalculator
    def self.within_radius?(calculate_request_model, person)
        distance = Haversine.distance(BigDecimal(calculate_request_model.latitude),
                                      BigDecimal(calculate_request_model.longitude),
                                      BigDecimal(person.latitude),
                                      BigDecimal(person.longitude))

        radius = calculate_request_model.radius
        case calculate_request_model.unit
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
end