module CLAideCompletion
  module Generator
    class ShellCompletionNotFound < StandardError
      include CLAide::InformativeError
    end

    autoload :Zsh, 'claide_completion/generator/zsh'

    def self.generate(command, shell = nil)
      shell ||= ENV['SHELL'].split(File::SEPARATOR).last
      begin
        generator = const_get(shell.capitalize.to_sym)
      rescue NameError
        raise ShellCompletionNotFound,  'Auto-completion generator for ' \
          "the `#{shell}` shell is not implemented."
      end
      generator.new(command).generate
    end

    # Indents the lines of the given string except the first one to the given
    # level. Uses two spaces per each level.
    #
    # @param  [String] string
    #         The string to indent.
    #
    # @param  [Fixnum] indentation
    #         The indentation amount.
    #
    # @return [String] An indented string.
    #
    def indent(string, indentation)
      string.gsub("\n", "\n#{' ' * indentation * 2}")
    end
    module_function :indent
  end
end
