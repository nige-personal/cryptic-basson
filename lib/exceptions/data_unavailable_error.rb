# frozen_string_literal: true

class DataUnavailableError < StandardError
  def initialize(msg='Data not available')
    super
  end
end
