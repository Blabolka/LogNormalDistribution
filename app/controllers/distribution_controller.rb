require_relative '../../lib/ProbabilityDensityFunction'
require_relative '../../lib/GeneratorCore'
require_relative '../../lib/NeymanMethod'
require_relative '../../lib/MetropolisMethod'
require_relative '../../lib/PiecewiseApproximationMethod'
require_relative '../../lib/MethodCalculationUtils'

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
    else
      return
    end

    if generation_count < 1 || max_x <= 0 || sigma <= 0
      return
    end

    generator = GeneratorCore.new(max_x, step, generation_count)
    pdf_calculation_lambda = -> (x) { ProbabilityDensityFunction.solve(sigma, mu, x) }
    pdf_mode_value = ProbabilityDensityFunction.mode(sigma, mu)
    pdf_mean_value = ProbabilityDensityFunction.mean(sigma, mu)
    pdf_variance_value = ProbabilityDensityFunction.variance(sigma, mu)
    pdf_maximum_value = ProbabilityDensityFunction.maximum_value(sigma, mu)

    neyman_method_lambda = -> () { NeymanMethod.calculate(pdf_calculation_lambda, pdf_maximum_value, max_x) }

    previous_x_result = pdf_mode_value
    metropolis_method_lambda = -> () {
      calculation_result = MetropolisMethod.calculate(pdf_calculation_lambda, max_x, previous_x_result)
      previous_x_result = calculation_result
      calculation_result
    }

    piecewise_sum_h = PiecewiseApproximationMethod.calculate_sum_h(pdf_calculation_lambda, max_x)
    piecewise_approximation_lambda = -> () { PiecewiseApproximationMethod.calculate(pdf_calculation_lambda, max_x, piecewise_sum_h) }

    neyman_method_data = generator.generate(neyman_method_lambda)
    metropolis_method_data = generator.generate(metropolis_method_lambda)
    piecewise_approximation_data = generator.generate(piecewise_approximation_lambda)

    methods_calculation = MethodCalculationUtils.new

    neyman_method_expected = methods_calculation.get_mean(
      neyman_method_data['count'],
      neyman_method_data['sum'],
    )
    metropolis_method_expected = methods_calculation.get_mean(
      metropolis_method_data['count'],
      metropolis_method_data['sum'],
    )
    piecewise_method_expected = methods_calculation.get_mean(
      piecewise_approximation_data['count'],
      piecewise_approximation_data['sum'],
    )

    neyman_method_variance = methods_calculation.get_variance(
      neyman_method_data['count'],
      neyman_method_data['sum'],
      neyman_method_data['sum_squares'],
    )
    metropolis_method_variance = methods_calculation.get_variance(
      metropolis_method_data['count'],
      metropolis_method_data['sum'],
      metropolis_method_data['sum_squares'],
    )
    piecewise_method_variance = methods_calculation.get_variance(
      piecewise_approximation_data['count'],
      piecewise_approximation_data['sum'],
      piecewise_approximation_data['sum_squares'],
    )

    @calculation_result = {
      'options' => {
        'generationCount' => generation_count,
        'max_x' => max_x,
        'step' => step,
        'sigma' => sigma,
        'mu' => mu
      },
      'pdfMaxValue' => pdf_maximum_value,
      'pdfMeanValue' => pdf_mean_value,
      'pdfVarianceValue' => pdf_variance_value,
      'neymanMethod' => neyman_method_data['frequencies'],
      'metropolisMethod' => metropolis_method_data['frequencies'],
      'piecewiseApproximationMethod' => piecewise_approximation_data['frequencies'],
      'neymanMethodExpectedValue' => neyman_method_expected,
      'metropolisMethodExpectedValue' => metropolis_method_expected,
      'piecewiseMethodExpectedValue' => piecewise_method_expected,
      'neymanMethodVariance' => neyman_method_variance,
      'metropolisMethodVariance' => metropolis_method_variance,
      'piecewiseMethodVariance' => piecewise_method_variance,
    }
  end
end
