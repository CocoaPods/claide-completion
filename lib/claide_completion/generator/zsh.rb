module CLAideCompletion
  module Generator
    # Generates a completion script for the Z shell.
    #
    class Zsh
      attr_reader :command

      # @param  [Class] command
      #         The command to generate the script for.
      #
      def initialize(command)
        @command = command
      end

      # @return [String] The completion script.
      #
      def generate
        result = <<-DOC
#compdef #{command.command}
# setopt XTRACE VERBOSE
# vim: ft=zsh sw=2 ts=2 et

local -a _subcommands
local -a _options

#{case_statement_fragment(command)}
DOC

        post_process(result)
      end

      private

      # Returns a case statement for a given command with the given nesting
      # level.
      #
      # @param  [Class] command
      #         The command to generate the fragment for.
      #
      # @param  [Fixnum] nest_level
      #         The nesting level to detect the index of the words array.
      #
      # @return [String] the case statement fragment.
      #
      # @example
      #   case "$words[2]" in
      #     spec-file)
      #       [..snip..]
      #     ;;
      #     *) # bin
      #       _subcommands=(
      #         "spec-file:"
      #       )
      #       _describe -t commands "bin subcommands" _subcommands
      #       _options=(
      #         "--completion-script:Print the auto-completion script"
      #         "--help:Show help banner of specified command"
      #         "--verbose:Show more debugging information"
      #         "--version:Show the version of the tool"
      #       )
      #       _describe -t options "bin options" _options
      #     ;;
      #   esac
      #
      # rubocop:disable MethodLength
      def case_statement_fragment(command, nest_level = 0)
        entries = case_statement_entries_fragment(command, nest_level + 1)
        subcommands = subcommands_fragment(command)
        options = options_fragment(command)

        result = <<-DOC
case "$words[#{nest_level + 2}]" in
  #{Generator.indent(entries, 1)}
  *) # #{command.full_command}
    #{Generator.indent(subcommands, 2)}
    #{Generator.indent(options, 2)}
  ;;
esac
DOC
        result.gsub(/\n *\n/, "\n").chomp
      end
      # rubocop:enable MethodLength

      # Returns a case statement for a given command with the given nesting
      # level.
      #
      # @param  [Class] command
      #         The command to generate the fragment for.
      #
      # @param  [Fixnum] nest_level
      #         The nesting level to detect the index of the words array.
      #
      # @return [String] the case statement fragment.
      #
      # @example
      #   repo)
      #     case "$words[5]" in
      #       *) # bin spec-file lint
      #         _options=(
      #           "--help:Show help banner of specified command"
      #           "--only-errors:Skip warnings"
      #           "--verbose:Show more debugging information"
      #         )
      #         _describe -t options "bin spec-file lint options" _options
      #       ;;
      #     esac
      #   ;;
      #
      def case_statement_entries_fragment(command, nest_level)
        subcommands = command.subcommands_for_command_lookup
        subcommands.sort_by(&:name).map do |subcommand|
          subcase = case_statement_fragment(subcommand, nest_level)
          <<-DOC
#{subcommand.command})
  #{Generator.indent(subcase, 1)}
;;
DOC
        end.join("\n")
      end

      # Returns the fragment of the subcommands array.
      #
      # @param  [Class] command
      #         The command to generate the fragment for.
      #
      # @return [String] The fragment.
      #
      def subcommands_fragment(command)
        subcommands = command.subcommands_for_command_lookup
        list = subcommands.sort_by(&:name).map do |subcommand|
          "\"#{subcommand.command}:#{subcommand.summary}\""
        end
        describe_fragment(command, 'subcommands', 'commands', list)
      end

      # Returns the fragment of the options array.
      #
      # @param  [Class] command
      #         The command to generate the fragment for.
      #
      # @return [String] The fragment.
      #
      def options_fragment(command)
        list = command.options.sort_by(&:first).map do |option|
          "\"#{option[0]}:#{option[1]}\""
        end
        describe_fragment(command, 'options', 'options', list)
      end

      # Returns the fragment for a list of completions and the ZSH
      # `_describe` function.
      #
      # @param  [Class] command
      #         The command to generate the fragment for.
      #
      # @param  [String] name
      #         The name of the list.
      #
      # @param  [Class] tag
      #         The ZSH tag to use (e.g. command or option).
      #
      # @param  [Array<String>] list
      #         The list of the entries.
      #
      # @return [String] The fragment.
      #
      def describe_fragment(command, name, tag, list)
        if list && !list.empty?
          <<-DOC
_#{name}=(
  #{Generator.indent(list.join("\n"), 1)}
)
_describe -t #{tag} "#{command.full_command} #{name}" _#{name}
DOC
        else
          ''
        end
      end

      # Post processes a script to remove any artifact and escape any needed
      # character.
      #
      # @param  [String] string
      #         The string to post process.
      #
      # @return [String] The post processed script.
      #
      def post_process(string)
        string.gsub!(/\n *\n/, "\n\n")
        string.gsub!(/`/, '\\\`')
        string
      end
    end
  end
end
