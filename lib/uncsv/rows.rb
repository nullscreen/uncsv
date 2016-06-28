require 'csv'

class Uncsv
  # A collection of parsed rows from a CSV
  class Rows
    # Create a new `Rows` object
    #
    # @param csv [CSV] A
    #   {http://ruby-doc.org/stdlib/libdoc/csv/rdoc/CSV.html CSV} object.
    # @param config [Config] Configuration options. Default options if `nil`.
    def initialize(csv, config = nil)
      @csv = csv
      @config = config || Config.new
      @started = false
      @parsed = nil
    end

    # Iterate over each row
    #
    # @yield A block to run for each row
    # @yieldparam row [Row] A row object
    # @return [Enumerator] An enumerator over each row
    def each(&block)
      Enumerator.new do |yielder|
        start
        index = parsed.index
        loop do
          break unless yield_row(yielder, index)
          index += 1
        end
      end.each(&block)
    end

    # Get the CSV header
    #
    # @return [Array] An array of the CSV header fields
    # @see Header#to_a
    def header
      parsed.header.to_a
    end

    private

    # Whether the given row should be skipped
    #
    # @param fields [Array] An array of field values
    # @param index [Integer] The zero-based row index
    # @return [Boolean] Whether the row should be skipped
    def should_skip?(fields, index)
      return true if @config.skip_rows[index]
      return true if @config.skip_blanks && fields.compact.empty?
      false
    end

    # Yield a row from the CSV to the Enumerator yielder
    #
    # Reads a row from the CSV and yields a parsed row if necessary.
    #
    # @param yielder [Enumerator::Yielder] A yielder to yield the row to
    # @param index [Integer] The next row index
    # @return [Boolean] `false` if the CSV is ended
    def yield_row(yielder, index)
      fields = @csv.shift
      return false unless fields
      unless should_skip?(fields, index)
        yielder << Row.new(header, fields, @config)
      end
      true
    end

    # Start reading the CSV
    #
    # If the CSV has already been read, it will be rewound and the header will
    # be reset.
    def start
      if @started
        @parsed = nil
        @csv.rewind
      else
        @started = true
      end
    end

    # Get the header parse object
    #
    # The parsed header is cached, so multiple calls will return the same
    # instance.
    #
    # @return [OpenStruct] The parsed header object
    def parsed
      @parsed ||= Header.parse!(@csv, @config)
    end
  end
end
