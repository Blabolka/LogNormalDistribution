require_relative '../../lib/GeneratorCore'
require_relative '../../lib/NeymanMethod'
require_relative '../../lib/MetropolisMethod'

class DistributionController < ApplicationController
  def index
    generation_count = 100000
    max_x = 2
    x_step = 0.1
    sigma = 0.25
    mu = 0

    generator = GeneratorCore.new(generation_count, max_x, x_step)

    neyman_method = NeymanMethod.new
    neyman_method_lambda = -> (current_x, previous_x) { neyman_method.calculate(current_x, sigma, mu) }
    @calculation_result = generator.generate(neyman_method_lambda)

    # metropolis_method = MetropolisMethod.new
    # metropolis_method_lambda = -> (current_x, previous_x) { metropolis_method.calculate(current_x, previous_x, sigma, mu) }
    # @calculation_result = generator.generate(metropolis_method_lambda)
  end
end
