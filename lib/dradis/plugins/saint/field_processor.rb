module Dradis
  module Plugins
    module Saint

      class FieldProcessor < Dradis::Plugins::Upload::FieldProcessor
        ALLOWED_DATA_NAMES = %w{evidence vulnerability host}

        def post_initialize(args={})
          raise 'Unhandled data name!' unless ALLOWED_DATA_NAMES.include?(data.name)
          @saint_object =
            "::Saint::#{data.name.capitalize}".constantize.new(data)
        end

        def value(args={})
          field = args[:field]
          _, name = field.split('.')

          # We cannot send the message 'class' to the saint_object because it
          # evaluates to the object's Ruby class. We temporarily rename the
          # field to 'vuln_class' and switch it back later when needed.
          if name == 'class'
            name = 'vuln_class'
          end

          @saint_object.try(name) || 'n/a'
        end
      end
    end
  end
end

