require_relative 'probabilityDensFunc'

class MetropolisMethod
  def calculate(current_x, previous_x, sigma, mu)
    gamma1 = rand
    gamma2 = rand
    delta = (1.0 / 3.0) * current_x
    x1 = previous_x + delta * (-1.0 + 2.0 * gamma1)

    first = probability_dens_func(sigma, mu, x1)
    second = probability_dens_func(sigma, mu, previous_x)

    if second <= 0
      return 0
    end

    alpha = first / second

    if alpha >= 1.0 || alpha > gamma2
      return x1
    end

    previous_x
  end
end