require_relative '../../lib/ProbabilityDensityFunction'
require_relative '../../lib/GeneratorCore'
require_relative '../../lib/NeymanMethod'

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

      pdf_maximum_value = ProbabilityDensityFunction.maximum_value(sigma, mu)
      pdf_calculation_lambda = -> (x) { ProbabilityDensityFunction.solve(sigma, mu, x) }
      neyman_method_lambda = -> () { NeymanMethod.calculate(pdf_maximum_value, max_x, pdf_calculation_lambda) }

      @calculation_result = generator.generate(neyman_method_lambda)
    end
  end
end
