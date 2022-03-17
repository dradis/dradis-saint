module Dradis::Plugins::Saint
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::Saint

    include ::Dradis::Plugins::Base
    description 'Processes SAINT XML format'
    provides :upload

    def self.template_names
      { module_parent => { evidence: 'evidence', issue: 'vulnerability' } }
    end
  end
end
