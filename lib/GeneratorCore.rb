class GeneratorCore
  def initialize(limit, step, generation_count)
    @generation_count = generation_count
    @limit = limit
    @step = step
  end

  def generate(method)
    frequencies = []

    ((0 + @step)..@limit).step(@step).each do |currentStep|
      current_success_method_results = 0
      previous_step = currentStep - @step

      (0..@generation_count).each do
        method_result = method.call
        if method_result > previous_step and method_result <= currentStep
          current_success_method_results += 1
        end
      end

      frequencies.push(current_success_method_results.to_f / @generation_count.to_f)
    end

    frequencies
  end
end