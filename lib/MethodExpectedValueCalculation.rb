class MethodExpectedValueCalculation
  def initialize(generation_count, right_boundary)
    @generation_count = generation_count
    @right_boundary = right_boundary
  end

  def calculate(method_calculation)
    expected_value = 0

    intervals_count = method_calculation.length
    method_calculation.each_with_index do |value, index|
      expected_value += (@right_boundary / intervals_count * index + @right_boundary / (intervals_count * 2)) * (value * 1.0 / @generation_count);
    end

    expected_value
  end
end