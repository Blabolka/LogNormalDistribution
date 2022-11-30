def probability_dens_func(sigma, mu, x)
  x <= 0 ? 0 : Math.exp(-(((Math.log(x) - mu) / sigma)**2 / 2)) / (x * sigma * Math.sqrt(2 * Math::PI))
end