require 'csv'

class Uncsv
  class Rows
    def initialize(csv, config = nil)
      @csv = csv
      @config = config || Config.new
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
      unless should_skip?(fields, index)
        yielder << Row.new(header, fields, @config)
      end
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
  end
end
