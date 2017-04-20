module Dradis
  module Plugins
    module Saint

      class FieldProcessor < Dradis::Plugins::Upload::FieldProcessor
        def post_initialize(args={})
          @saint_object = ::Saint::Vulnerability.new(data)
        end

        def value(args={})
          field = args[:field]
          @saint_object.try(field)
        end
      end
    end
  end
end

