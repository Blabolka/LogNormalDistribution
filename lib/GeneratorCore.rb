class GeneratorCore
  def initialize(generation_count, max_right_boundary, sigma, mu)
    @generation_count = generation_count
    @max_right_boundary = max_right_boundary
    @sigma = sigma
    @mu = mu
  end

  def generate(step, &method)
    calculations_array = []

    (0..@max_right_boundary).step(step).each do |current_max_boundary|
      calculation_sum = 0

      (1..@generation_count).each do |i|
        calculation_sum += method.call(current_max_boundary, @sigma, @mu)
      end

      arithmetic_mean = calculation_sum / @generation_count
      puts current_max_boundary
      puts arithmetic_mean
      puts ''
      calculations_array.push(arithmetic_mean)
    end

    calculations_array
  end
end