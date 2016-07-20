class Uncsv
  # A single data row from a CSV. Fields can be accessed by header or zero-based
  # index.
  class Row
    include Enumerable

    # The headers for each field
    #
    # If a header for a given field is not defined, it will be `nil`.
    #
    # @return [Array] An array of the field headers
    attr_reader :header

    # The fields ordered from left to right
    #
    # An array of zero-indexed field values. If a field is empty it will be
    # `nil`, or `''` if `nil_empty` is `false`.
    #
    # @return [Array] An array of the field values
    attr_reader :fields

    # Create a new `Row` object
    #
    # The `header` and `fields` arrays do not need to be the same length. If
    # they are not, the missing values will be filled with `nil`.
    #
    # @param header [Array] The field headers
    # @param fields [Array] The field values
    # @param config [Config] Configuration options. Default options if `nil`.
    def initialize(header, fields, config = nil)
      @config = config || Config.new
      @header = square(header, fields.size)
      @fields = square(fields, header.size).map { |f| process(f) }
      @map = Hash[header.zip(@fields)]
    end

    # Get a field by index or header
    #
    # If `key` is an `Integer`, get a field by a zero-based index. If `key` is a
    # header, access a field by it's header. If `key` is nil, or if a field does
    # not exist, will return `nil`.
    #
    # @param key [Integer, String] The index or header
    # @return [String, nil] The field value if it exists
    def [](key)
      return if key.nil?
      value = key.is_a?(Integer) ? @fields[key] : @map[key]
      process(value)
    end

    # Gets a hash of headers to fields
    #
    # `nil` headers will not be included in the hash.
    #
    # @return [Hash] A hash of headers to fields
    def to_h
      Hash[@header.compact.map { |h| [h, self[h]] }]
    end

    # Iterate over each pair of headers and fields
    #
    # @yield A block to run for each pair
    # @yieldparam row [Row] A row object
    # @return [Enumerator] An enumerator over each pair
    def each(&block)
      @map.each_pair(&block)
    end

    # Get a field by index or header and specify a default
    #
    # Tries to get the field specified by key (see {#[]}). If the field
    # is `nil`, returns the default. If a block is given, the default is the
    # block's return value, otherwise the default is the `default` argument.
    #
    # @yield A block to run if the field is `nil`
    # @yieldparam key [String] The `key` parameter
    # @return [String, Object] The field value or default
    def fetch(key, default = nil)
      value = self[key]
      return value unless value.nil?
      block_given? ? yield(key) : default
    end

    private

    # Fills an array with nil to extend it to the given size
    #
    # @param array [Array] The array to square
    # @param size [Integer] The target array size
    # @return [Array] The squared array
    def square(array, size)
      array.fill(nil, array.size, size - array.size)
    end

    # Transforms a field value according to the config options
    #
    # @param field [String] The field value to process
    # @return [String] The processed field
    def process(field)
      field = '' if field.nil? && !@config.nil_empty
      field = nil if field == '' && @config.nil_empty
      field
    end
  end
end
