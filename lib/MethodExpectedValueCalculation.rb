class MethodExpectedValueCalculation
  def initialize(generation_count, right_boundary)
    @generation_count = generation_count
    @right_boundary = right_boundary
  end

  def calculate(method_frequencies)
    expected_value = 0.0

    intervals_count = method_frequencies.length
    method_frequencies.each_with_index do |single_frequency_value, index|
      value = single_frequency_value * @generation_count
      expected_value += (@right_boundary / intervals_count * index + @right_boundary / (intervals_count * 2)) * (value * 1.0 / @generation_count)
    end

    expected_value
  end
end