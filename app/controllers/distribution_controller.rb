require_relative '../../lib/ProbabilityDensityFunction'
require_relative '../../lib/GeneratorCore'
require_relative '../../lib/NeumannMethod'
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
    total_generations_count = generator.get_total_generations_count

    pdf_calculation_lambda = -> (x) { ProbabilityDensityFunction.solve(sigma, mu, x) }
    pdf_mode_value = ProbabilityDensityFunction.mode(sigma, mu)
    pdf_mean_value = ProbabilityDensityFunction.mean(sigma, mu)
    pdf_variance_value = ProbabilityDensityFunction.variance(sigma, mu)
    pdf_deviation_value = ProbabilityDensityFunction.deviation(sigma, mu, total_generations_count)
    pdf_maximum_value = ProbabilityDensityFunction.maximum_value(sigma, mu)

    neumann_method_lambda = -> () { NeumannMethod.calculate(pdf_calculation_lambda, pdf_maximum_value, max_x) }

    previous_x_result = pdf_mode_value
    metropolis_method_lambda = -> () {
      calculation_result = MetropolisMethod.calculate(pdf_calculation_lambda, max_x, previous_x_result)
      previous_x_result = calculation_result
      calculation_result
    }

    piecewise_sum_h = PiecewiseApproximationMethod.calculate_sum_h(pdf_calculation_lambda, max_x)
    piecewise_approximation_lambda = -> () { PiecewiseApproximationMethod.calculate(pdf_calculation_lambda, max_x, piecewise_sum_h) }

    neumann_method_data = generator.generate(neumann_method_lambda)
    metropolis_method_data = generator.generate(metropolis_method_lambda)
    piecewise_approximation_data = generator.generate(piecewise_approximation_lambda)

    methods_calculation = MethodCalculationUtils.new

    neumann_method_expected = methods_calculation.get_mean(
      total_generations_count,
      neumann_method_data['sum'],
    )
    metropolis_method_expected = methods_calculation.get_mean(
      total_generations_count,
      metropolis_method_data['sum'],
    )
    piecewise_method_expected = methods_calculation.get_mean(
      total_generations_count,
      piecewise_approximation_data['sum'],
    )

    neumann_method_variance = methods_calculation.get_variance(
      total_generations_count,
      neumann_method_data['sum'],
      neumann_method_data['sum_squares'],
    )
    metropolis_method_variance = methods_calculation.get_variance(
      total_generations_count,
      metropolis_method_data['sum'],
      metropolis_method_data['sum_squares'],
    )
    piecewise_method_variance = methods_calculation.get_variance(
      total_generations_count,
      piecewise_approximation_data['sum'],
      piecewise_approximation_data['sum_squares'],
    )

    neumann_method_deviation = methods_calculation.get_deviation(
      total_generations_count,
      neumann_method_data['sum'],
      neumann_method_data['sum_squares'],
      )
    metropolis_method_deviation = methods_calculation.get_deviation(
      total_generations_count,
      metropolis_method_data['sum'],
      metropolis_method_data['sum_squares'],
      )
    piecewise_method_deviation = methods_calculation.get_deviation(
      total_generations_count,
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
      'pdfDeviationValue' => pdf_deviation_value,
      'neumannMethod' => neumann_method_data['frequencies'],
      'metropolisMethod' => metropolis_method_data['frequencies'],
      'piecewiseApproximationMethod' => piecewise_approximation_data['frequencies'],
      'neumannMethodExpectedValue' => neumann_method_expected,
      'metropolisMethodExpectedValue' => metropolis_method_expected,
      'piecewiseMethodExpectedValue' => piecewise_method_expected,
      'neumannMethodVariance' => neumann_method_variance,
      'metropolisMethodVariance' => metropolis_method_variance,
      'piecewiseMethodVariance' => piecewise_method_variance,
      'neumannMethodDeviation' => neumann_method_deviation,
      'metropolisMethodDeviation' => metropolis_method_deviation,
      'piecewiseMethodDeviation' => piecewise_method_deviation,
    }
  end
end
