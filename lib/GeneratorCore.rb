class GeneratorCore
  def initialize(limit, step, generation_count)
    @generation_count = generation_count
    @limit = limit
    @step = step
  end

  def generate(method)
    frequencies = []
    count = 0
    sum = 0
    sum_squares = 0

    ((0 + @step)..@limit).step(@step).each do |currentStep|
      current_success_method_results = 0
      previous_step = currentStep - @step

      (0..@generation_count).each do
        method_result = method.call
        count += 1
        sum += method_result
        sum_squares += method_result**2

        if method_result > previous_step and method_result <= currentStep
          current_success_method_results += 1
        end
      end

      frequencies.push(current_success_method_results.to_f / @generation_count)
    end

    {
      'frequencies' => frequencies,
      'count' => count,
      'sum' => sum,
      'sum_squares' => sum_squares,
    }
  end
end