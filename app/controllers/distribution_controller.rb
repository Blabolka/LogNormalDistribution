require_relative '../../lib/ProbabilityDensityFunction'
require_relative '../../lib/GeneratorCore'
require_relative '../../lib/NeymanMethod'
require_relative '../../lib/MetropolisMethod'

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
      pdf_calculation_lambda = -> (x) { ProbabilityDensityFunction.solve(sigma, mu, x) }

      pdf_maximum_value = ProbabilityDensityFunction.maximum_value(sigma, mu)
      neyman_method_lambda = -> () { NeymanMethod.calculate(pdf_calculation_lambda, pdf_maximum_value, max_x) }

      previous_method_result = 0
      metropolis_method_lambda = -> () {
        calculation_result = MetropolisMethod.calculate(pdf_calculation_lambda, max_x, previous_method_result)
        previous_method_result = calculation_result
        calculation_result
      }

      @calculation_result = {
        'options' => {
          'max_x' => max_x,
          'step' => step,
        },
        'neymanMethod' => generator.generate(neyman_method_lambda),
        'metropolisMethod' => generator.generate(metropolis_method_lambda)
      }
    end
  end
end
