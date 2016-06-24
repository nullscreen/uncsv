require 'csv'

class Uncsv
  class Rows
    def initialize(csv, config)
      @csv = csv
      @config = config
    end

    def each(&block)
      parsed = Header.parse!(@csv, @config)
      index = parsed.index
      Enumerator.new do |yielder|
        loop do
          break unless yield_row(yielder, parsed, index)
          index += 1
        end
      end.each(&block)
    end

    private

    def should_skip?(fields, index)
      return true if @config.skip_rows[index]
      return true if @config.skip_blanks && fields.compact.empty?
      false
    end

    def yield_row(yielder, parsed, index)
      fields = @csv.shift
      return false unless fields
      unless should_skip?(fields, index)
        yielder << CSV::Row.new(parsed.header.to_a, fields)
      end
      true
    end
  end
end
