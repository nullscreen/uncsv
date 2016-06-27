require 'ostruct'

class Uncsv
  class Config
    CSV_OPTS = [
      :col_sep, :row_sep, :quote_char, :field_size_limit, :converters
    ].freeze

    attr_accessor :expand_headers, :header_rows, :header_separator,
      :nil_empty, :normalize_headers, :skip_blanks, :skip_rows, :unique_headers,
      *CSV_OPTS

    def initialize(opts = {})
      default_opts.merge(opts).each { |k, v| public_send("#{k}=", v) }
    end

    def skip_rows=(rows)
      rows = [rows] unless rows.is_a?(Array)
      @skip_rows = Hash[rows.map { |r| [r, true] }]
    end

    def header_rows=(rows)
      rows = [rows] unless rows.is_a?(Array)
      @header_rows = rows.sort
    end

    def csv_opts
      Hash[
        CSV_OPTS
          .map { |k| [k, public_send(k)] }
          .select { |o| !o[1].nil? }
      ]
    end

    def expanded_headers
      return header_rows if expand_headers == true
      return [] if expand_headers == false
      expand_headers
    end

    private

    def default_opts
      {
        expand_headers: false,
        header_rows: [],
        header_separator: '.',
        nil_empty: true,
        normalize_headers: false,
        skip_rows: {},
        skip_blanks: false,
        unique_headers: false
      }
    end
  end
end
