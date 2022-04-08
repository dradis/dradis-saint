module Dradis::Plugins::Saint
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::Saint

    include ::Dradis::Plugins::Base
    description 'Processes SAINT XML format'
    provides :upload
  end
end
