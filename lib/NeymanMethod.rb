require_relative 'ProbabilityDensityFunction'

class NeymanMethod
  def self.calculate(maximum_value, right_boundary, function_callback)
    while true
      x = rand(0.0..1.0) * right_boundary
      y = rand(0.0..1.0) * maximum_value

      if function_callback.call(x) > y
        return x
      end
    end
  end
end