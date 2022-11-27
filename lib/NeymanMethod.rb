require_relative 'probabilityDensFunc'

class NeymanMethod
  def calculate(right_boundary, sigma, mu)
    x1 = 0
    x2 = 0
    while true
      x1 = rand(x1)
      x2 = rand(x2)

      x1 *= right_boundary
      x2 *= maximum_value(sigma, mu)

      if x2 <= probability_dens_func(sigma, mu, x1)
        break
      end
    end

    x1
  end

  private def maximum_value(sigma, mu)
    moda = Math::E**(mu - sigma**2)

    probability_dens_func(sigma, mu, moda)
  end
end