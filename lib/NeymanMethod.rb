require_relative 'probabilityDensFunc'

class NeymanMethod
  def calculate(generation_limit, sigma, mu)
    generation_count = 0
    success_generation_count = 0

    max_value = maximum_value(sigma, mu)

    while generation_count < generation_limit
      x = rand(0.0..1.0)
      y = rand(0.0..1.0) * max_value

      if probability_dens_func(sigma, mu, x) > y
        success_generation_count += 1
      end

      generation_count += 1
    end

    success_generation_count
  end

  private def maximum_value(sigma, mu)
    mode = Math::E**(mu - sigma**2)

    probability_dens_func(sigma, mu, mode)
  end
end