class CalculateRequestModel
    attr_accessor :longitude, :latitude, :radius, :calcAvgValue, :unit

    def initialize(lon:, lat:,  calcAvgValue:, radius: nil, unit: nil)
        @longitude = lon
        @latitude = lat
        @radius = radius
        @calcAvgValue = calcAvgValue
        @unit = unit
    end
end