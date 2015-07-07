require 'claide_completion/generator'

module CLAideCompletion
  def self.included(mod)
    if defined?(mod::DEFAULT_ROOT_OPTIONS)
      mod::DEFAULT_ROOT_OPTIONS << [
        '--completion-script', 'Print the auto-completion script'
      ]
    end
    mod.send(:prepend, Prepend)
  end

  module Prepend
    def handle_root_options(argv)
      return false unless self.class.root_command?
      if argv.flag?('completion-script')
        puts Generator.generate(self.class)
        return true
      end
      super
    end
  end
end
