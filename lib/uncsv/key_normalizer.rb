# frozen_string_literal: true

class Uncsv
  # Normalizes strings into a consistant format
  class KeyNormalizer
    # The default values applied if an attribute's value is not specified when
    # constructing a new `KeyNormalizer` object.
    DEFAULTS = {
      downcase: true,
      separator: '_'
    }.freeze

    # A string to replace all non-alphanumeric characters in the key
    #
    # Default: '_'. Can be set to an empty string to remove non-alphanumeric
    # characters without replacing them.
    #
    # @return [String] The separator string
    attr_accessor :separator

    # Sets keys to all lower-case if set to `true`
    #
    # Default: true
    #
    # @return [Boolean] Whether the key will be lower-cased
    attr_accessor :downcase

    # Create a new `KeyNormalizer` object.
    #
    # Options will be set to the defaults unless overridden by the `opts`
    # parameter.
    #
    # @param opts [Hash] A hash of configuration options. See the individual
    #   attributes for detailed descriptions.
    def initialize(opts = {})
      DEFAULTS.merge(opts).each { |k, v| public_send("#{k}=", v) }
    end

    # Normalize a key
    #
    # Replaces non-alphanumeric characters with `separator`, then
    # deduplicates underscores and trims them from the ends of the key. Then
    # the key is lower-cased if `downcase` is set.
    #
    # @param key [String, nil] The key field to normalize
    # @return [String, nil] The normalized header field or `nil` if the input
    #   key is `nil`.
    def normalize(key)
      return nil if key.nil?

      key = key.gsub(/[^a-z0-9]+/i, separator)
      unless separator.empty?
        escaped_separator = Regexp.escape(separator)
        key.gsub!(/#{escaped_separator}{2,}/, separator)
        key.gsub!(/^#{escaped_separator}|#{escaped_separator}$/, '')
      end
      key.downcase! if downcase
      key
    end
  end
end
