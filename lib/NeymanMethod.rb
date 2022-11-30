require_relative 'probabilityDensFunc'

class NeymanMethod
  def calculate(right_boundary, sigma, mu)
    max_value = maximum_value(sigma, mu)

    while true
      x = rand(0.0..1.0) * right_boundary
      y = rand(0.0..1.0) * max_value

      if probability_dens_func(sigma, mu, x) > y
        return x
      end
    end
  end

  private def maximum_value(sigma, mu)
    mode = Math::E**(mu - sigma**2)

    probability_dens_func(sigma, mu, mode)
  end
end