require_relative '../../lib/GeneratorCore'
require_relative '../../lib/NeymanMethod'

class DistributionController < ApplicationController
  def index
    generator = GeneratorCore.new(100000, 2, 0.25, 0)

    neyman_method = NeymanMethod.new
    @calculation_result = generator.generate(0.1, &neyman_method.method(:calculate))
  end
end
