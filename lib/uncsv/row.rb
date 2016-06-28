class Uncsv
  class Row
    include Enumerable

    attr_reader :header, :fields

    def initialize(header, fields, config = nil)
      @config = config || Config.new
      @header = square(header, fields.size)
      @fields = square(fields, header.size).map { |f| process(f) }
      @map = Hash[header.zip(@fields)]
    end

    def [](key)
      return if key.nil?
      value = key.is_a?(Integer) ? @fields[key] : @map[key]
      process(value)
    end

    def to_h
      Hash[@header.map { |h| [h, self[h]] }]
    end

    def each(&block)
      @map.each_pair(&block)
    end

    def fetch(key, default = nil)
      self[key] || (block_given? ? yield(key) : default)
    end

    private

    def square(array, size)
      array.fill(nil, array.size, size - array.size)
    end

    def process(field)
      field = '' if field.nil? && !@config.nil_empty
      field
    end
  end
end
