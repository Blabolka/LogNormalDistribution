class GeneratorCore
  def initialize(generation_count, max_x, x_step)
    @generation_count = generation_count
    @max_x = max_x
    @x_step = x_step
  end

  def generate(method)
    calculations_array = []

    previous_x = 0
    (0..@max_x).step(@x_step).each do |current_x|
      calculation_sum = 0

      (1..@generation_count).each do
        calculation_sum += method.call(current_x, previous_x)
      end

      arithmetic_mean = calculation_sum / @generation_count
      calculations_array.push(arithmetic_mean)
      previous_x = current_x
    end

    calculations_array
  end
end