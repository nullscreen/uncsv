require 'csv'

class Uncsv
  class Rows
    def initialize(csv, config)
      @csv = csv
      @config = config
      @started = false
      @parsed = nil
    end

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

    def header
      parsed.header.to_a
    end

    private

    def should_skip?(fields, index)
      return true if @config.skip_rows[index]
      return true if @config.skip_blanks && fields.compact.empty?
      false
    end

    def yield_row(yielder, index)
      fields = @csv.shift
      return false unless fields
      process_fields!(fields)
      yielder << CSV::Row.new(header, fields) unless should_skip?(fields, index)
      true
    end

    def start
      if @started
        @parsed = nil
        @csv.rewind
      else
        @started = true
      end
    end

    def parsed
      @parsed ||= Header.parse!(@csv, @config)
    end

    def process_fields!(fields)
      stringify_nils!(fields) unless @config.nil_empty
      fields
    end

    def stringify_nils!(fields)
      fields.map! { |f| f.nil? ? '' : f }
    end
  end
end
