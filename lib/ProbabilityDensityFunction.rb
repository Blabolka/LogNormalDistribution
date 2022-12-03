class ProbabilityDensityFunction
  def self.solve(sigma, mu, x)
    Math.exp(-(((Math.log(x) - mu) / sigma)**2 / 2)) / (x * sigma * Math.sqrt(2 * Math::PI))
  end

  def self.mode(sigma, mu)
    Math.exp(mu - sigma**2)
  end

  def self.maximum_value(sigma, mu)
    mode = mode(sigma, mu)
    ProbabilityDensityFunction.solve(sigma, mu, mode)
  end

  def self.mean(sigma, mu)
    Math.exp(mu + (sigma**2 / 2.0))
  end

  def self.variance(sigma, mu)
    (Math.exp(sigma**2) - 1) * Math.exp(2*mu + sigma**2)
  end

  def self.deviation(sigma, mu, generation_count)
    variance = ProbabilityDensityFunction.variance(sigma, mu)
    Math.sqrt(variance / generation_count)
  end
end
