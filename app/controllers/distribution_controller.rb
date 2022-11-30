require_relative '../../lib/GeneratorCore'
require_relative '../../lib/NeymanMethod'
require_relative '../../lib/probabilityDensFunc'

class DistributionController < ApplicationController
  def index
    generation_count = params['generation-count']
    max_x = params['right-boundary']
    sigma = params['sigma']
    mu = params['mu']
    step = 0.1

    if generation_count && max_x && sigma && mu
      generation_count = generation_count.to_i
      max_x = max_x.to_f
      sigma = sigma.to_f
      mu = mu.to_f

      generator = GeneratorCore.new(max_x, step, generation_count)

      neyman_method = NeymanMethod.new
      neyman_method_lambda = -> () { neyman_method.calculate(max_x, sigma, mu) }
      @calculation_result = generator.generate(neyman_method_lambda)
    end
  end
end
