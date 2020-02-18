module Dradis
  module Plugins
    module Saint
      def self.gem_version
        Gem::Version.new VERSION::STRING
      end

      module VERSION
        MAJOR = 3
        MINOR = 16
        TINY = 0
        PRE = nil

        STRING = [MAJOR, MINOR, TINY, PRE].compact.join(".")
      end
    end
  end
end
