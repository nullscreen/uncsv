class Uncsv
  # A parsed CSV header.
  class Header
    # Create a new `Header` object
    #
    # @param headers [Array<Array<String>>] An array of header row values
    # @param config [Config] Configuration options. Default options if `nil`.
    def initialize(headers, config = nil)
      @headers = headers
      @config = config || Config.new
      @array = nil
    end

    # Iterate over each header field
    #
    # @yield A block to run for each header field
    # @yieldparam row [String] A header field
    # @return [Enumerator] An enumerator over header field
    def each(&block)
      to_a.each(&block)
    end

    # Get an array of parsed header fields
    #
    # The header fields are cached, so consecutive calls to this method return
    # the same array.
    #
    # @return [Array] The array of header fields
    def to_a
      @array ||= begin
        headers = nil_empty(@headers)
        headers = square(headers)
        headers = normalize(headers) if @config.normalize_headers
        headers = expand(headers)
        combined = combine(headers)
        combined = unique(combined) if @config.unique_headers
        combined
      end
    end

    class << self
      # Parse headers from a CSV
      #
      # @param csv [CSV] A
      #   {http://ruby-doc.org/stdlib/libdoc/csv/rdoc/CSV.html CSV} object.
      # @param config [Config] Configuration options. Default options if `nil`.
      # @return [OpenStruct] An object with the methods `header`, `index`, and
      #   `rows`. `header` is the {Header} object. `index` is the next CSV row
      #   index. `rows` is an array of the skipped rows including the header
      #   rows.
      def parse!(csv, config)
        index = config.header_rows.empty? ? 0 : (config.header_rows.max + 1)
        rows = read_rows(csv, index)
        headers = config.header_rows.map { |i| rows[i] }
        OpenStruct.new(
          header: new(headers, config),
          index: index,
          rows: rows
        )
      end

      private

      # Read a given number of rows from a CSV
      #
      # @param csv [CSV] A
      #   {http://ruby-doc.org/stdlib/libdoc/csv/rdoc/CSV.html CSV} object to
      #   read rows from.
      # @param count [Integer] The number of rows to read
      # @return [Array<Array<String>>] An array of the read rows
      def read_rows(csv, count)
        (0...count).map { csv.shift }
      end
    end

    private

    # Combine multiple headers into a single header
    #
    # Joins individual headers with the `header_separator`.
    #
    # @param headers [Array<Array<String>>] The headers to combine
    # @return [Array<String>] The combined header
    def combine(headers)
      headers.each_with_object([]) do |header, combined|
        header.each_with_index do |key, index|
          parts = [combined[index], key].compact
          if parts.empty?
            combined[index] = nil
          else
            combined[index] = parts.join(@config.header_separator)
          end
        end
      end
    end

    # Fills in `nil` headers from the left
    #
    # @param headers [Array<Array<String>>] The headers to expand
    # @return [Array<Array<String>>] The expanded headers
    def expand(headers)
      headers.each_with_index.map do |header, index|
        next header unless @config.expand_headers.include?(index)
        last = nil
        header.map do |key|
          key ? last = key : last
        end
      end
    end

    # Unique headers by adding numbers to the end
    #
    # @param combined [Array<String>] The combined headers to unique
    # @return [Array<String>] The uniqued headers
    def unique(combined)
      combined = combined.dup
      collate(combined).each do |key, indexes|
        next if indexes.size == 1
        indexes.each_with_index do |index, count|
          combined[index] = [key, count].compact.join(@config.header_separator)
        end
      end
      combined
    end

    # Create a hash of headers to arrays of their indexes
    #
    # Used for checking for header uniqueness
    #
    # @param header [Array<String>] The combined header to collate
    # @return [Hash] The collated headers
    def collate(header)
      collated = {}
      header.each_with_index do |key, index|
        collated[key] = (collated[key] || []) << index
      end
      collated
    end

    # Normalize header values
    #
    # @param headers [Array<Array<String>>] The array of uncombined headers to
    #   normalize
    def normalize(headers)
      headers.map do |header|
        header.map do |key|
          normalize_key(key)
        end
      end
    end

    # Normalize a header key
    #
    # Replaces non-alphanumeric characters with underscores, then deduplicates
    # underscores and trims them from the ends of the key. Then the key is
    # lower-cased.
    #
    # @param key [String, nil] The header field to normalize
    # @return [String, nil] The normalized header field or `nil` if the header
    #   is not set
    def normalize_key(key)
      return nil if key.nil?
      normalize_headers = @config.normalize_headers
      separator = normalize_headers.is_a?(String) ? normalize_headers : '_'

      key = key.gsub(/[^a-z0-9_]+/i, separator)
      unless separator.empty?
        escaped_separator = Regexp.escape(separator)
        key.gsub!(/#{escaped_separator}{2,}/, separator)
        key.gsub!(/^#{escaped_separator}|#{escaped_separator}$/, '')
      end
      key.downcase
    end

    # Make the headers all the same length
    #
    # @param headers [Array<Array<String>>] An array of headers to square
    # @return [Array<Array<String>>] The squared headers
    def square(headers)
      length = headers.map(&:size).max
      headers.map { |h| h.fill(nil, h.size, length - h.size) }
    end

    # Convert header empty strings to nil
    #
    # @param headers [Array<Array<String>>] An array of headers to convert
    # @return [Array<Array<String>>] The converted headers
    def nil_empty(headers)
      headers.map { |h| h.map { |k| k == '' ? nil : k } }
    end
  end
end
