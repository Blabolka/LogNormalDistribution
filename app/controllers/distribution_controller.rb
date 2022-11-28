require_relative '../../lib/NeymanMethod'

class DistributionController < ApplicationController
  def index
    generation_count = 1000000
    mu = 0
    sigma = 0.25

    neyman_method = NeymanMethod.new
    @calculation_result = neyman_method.calculate(generation_count, sigma, mu)
  end
end
