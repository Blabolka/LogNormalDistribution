class ProbabilityDensityFunction
  def self.solve(sigma, mu, x)
    x <= 0 ? 0 : Math.exp(-(((Math.log(x) - mu) / sigma)**2 / 2)) / (x * sigma * Math.sqrt(2 * Math::PI))
  end

  def self.maximum_value(sigma, mu)
    mode = Math::E**(mu - sigma**2)

    ProbabilityDensityFunction.solve(sigma, mu, mode)
  end
end
