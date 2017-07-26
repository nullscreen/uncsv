class Uncsv
  # Configuration options for parsing CSVs. It is a struct-like object with
  # attribute acessors.
  class Config
    # Options that directly map to Std-lib `CSV` options
    CSV_OPTS = %i[
      col_sep row_sep quote_char field_size_limit
    ].freeze

    # The default values applied if an attribute's value is not specified when
    # constructing a new `Config` object.
    DEFAULTS = {
      col_sep: ',',
      expand_headers: false,
      field_size_limit: nil,
      header_rows: [],
      header_separator: '.',
      nil_empty: true,
      normalize_headers: false,
      quote_char: '"',
      row_sep: :auto,
      skip_rows: [],
      skip_blanks: false,
      unique_headers: false
    }.freeze

    # The string that separates each field
    #
    # Default: `","`.
    #
    # @return [String] The column separator string
    # @see (see #initialize)
    attr_accessor :col_sep

    # Whether to fill empty headers with values from the left.
    #
    # Default `false`. If set to `true`, blank header row cells will assume the
    # header of the row to their left. This is useful for heirarchical headers
    # where not all the header cells are filled in. If set to an array of header
    # indexes, only the specified headers will be expanded.
    #
    # @return [Array] An array of expaned header indexes
    attr_accessor :expand_headers

    # The maximum size CSV will read ahead looking for a closing quote.
    #
    # Default: `nil`.
    #
    # @return [nil, Integer] The maximum field size
    # @see (see #initialize)
    attr_accessor :field_size_limit

    # Indexes of the rows to use as headers
    #
    # Default: `[]`. Accepts an array of zero-based indexes or a single index.
    # For example, it could be set to `0` to indicate a header in the first row.
    # If set to an array of indexes (`[1,2]`), the header row text will be
    # joined by the `:header_separator`. For example, if if the cell (0,0) had
    # the value `"Personal"` and cell (1,0) had the value "Name", the header
    # would become `"Personal.Name"`. Any data above the last header row will be
    # ignored.
    #
    # @return [Array] The header row indexes
    attr_accessor :header_rows

    # The separator between multiple header fields
    #
    # Default: `"."`. When using multiple header rows, this is a string used
    # to separate the individual header fields.
    #
    # @return [String] The separator string
    attr_accessor :header_separator

    # Whether to represent empty cells as `nil`.
    #
    # Default `false`. If `true`, empty cells will be set to `nil`, otherwise,
    # they are set to an empty string.
    #
    # @return [Boolean] Whether empty cells will be `nil`ed
    attr_accessor :nil_empty

    # Whether to rewrite headers to a standard format
    #
    # Default `false`. If set to `true`, header field text will be normalized.
    # The text will be lowercased, and non-alphanumeric characters will be
    # replaced with underscores (`_`).
    #
    # If set to a string, those characters will
    # be replaced with the string instead.
    #
    # If set to a hash, the hash will be treated as options to KeyNormalizer,
    # accepting the `:separator`, and `:downcase` options.
    #
    # If set to another object, it is expected to respond to the
    # `normalize(key)` method by returning a normalized string.
    #
    # @see KeyNormalizer
    # @return [KeyNormalizer, Object] The KeyNormalizer object or equivalent
    attr_accessor :normalize_headers

    # The character used to quote individual fields
    #
    # Default `'"'`. If set to `true`, header field text will be normalized. The
    # text will be lowercased, and non-alphanumeric characters will be replaced
    # with underscores (`_`). If set to a string, those characters will be
    # replaced with the string instead.
    #
    # @return [String] The quote character
    # @see (see #initialize)
    attr_accessor :quote_char

    # The string at the end of each row
    #
    # Default `:auto`.
    #
    # @return [:auto, String] The row separator
    # @see (see #initialize)
    attr_accessor :row_sep

    # Whether to skip blank rows
    #
    # Default `false`. If `true`, rows whose fields are all empty will be
    # skipped.
    #
    # @return [Boolean] Whether blank rows will be skipped
    attr_accessor :skip_blanks

    # An array of row indexes to skip
    #
    # Default `[]`. If set to an array of zero-based row indexes, those rows
    # will be skipped. This option does not apply to header rows.
    #
    # @return [Array] The row index to skip
    attr_accessor :skip_rows

    # Whether to force headers to be unique
    #
    # Default `false`. If set to `true`, headers will be forced to be unique by
    # appending numbers to duplicates. For example, if two header cells have the
    # text `"Name"`, the headers will become `"Name.0"`, and `"Name.1"`. The
    # separator between the text and the number can be set using the
    # `:header_separator` option.
    #
    # @return [Boolean] Whether headers will be uniqued
    attr_accessor :unique_headers

    # Create a new `Config` object.
    #
    # Options will be set to the defaults unless overridden by the `opts`
    # parameter.
    #
    # @param opts [Hash] A hash of configuration options. See the individual
    #   attributes for detailed descriptions.
    #
    # @see http://ruby-doc.org/stdlib/libdoc/csv/rdoc/CSV.html#method-c-new
    #   CSV#new
    def initialize(opts = {})
      DEFAULTS.merge(opts).each { |k, v| public_send("#{k}=", v) }
    end

    def skip_rows=(rows)
      rows = [rows] unless rows.is_a?(Array)
      @skip_rows = Hash[rows.map { |r| [r, true] }]
    end

    def header_rows=(rows)
      rows = [rows] unless rows.is_a?(Array)
      @header_rows = rows.sort
    end

    def expand_headers=(value)
      value = [value] if value.is_a?(Integer)
      @expand_headers = value
    end

    def normalize_headers=(value)
      if value.is_a?(Hash)
        value = KeyNormalizer.new(value)
      elsif value.is_a?(String)
        value = KeyNormalizer.new(separator: value)
      elsif value == true
        value = KeyNormalizer.new
      end
      @normalize_headers = value
    end

    def expand_headers
      return header_rows if @expand_headers == true
      return [] if @expand_headers == false
      @expand_headers
    end

    # Get options passed through to `CSV#new`.
    #
    # @return [Hash] A hash of the CSV options
    # @see (see #initialize)
    def csv_opts
      Hash[CSV_OPTS.map { |k| [k, public_send(k)] }]
    end
  end
end
