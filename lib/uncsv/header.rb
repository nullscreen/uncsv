require 'ostruct'

class Uncsv
  class Header
    def initialize(headers, config)
      @headers = headers
      @config = config
    end

    def each(&block)
      to_a.each(&block)
    end

    def to_a
      @array ||= begin
        headers = square(@headers)
        headers = normalize(headers) if @config.normalize_headers
        headers = expand(headers) if @config.expand_headers
        combined = combine(headers)
        combined = unique(combined) if @config.unique_headers
        combined
      end
    end

    class << self
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

      def read_rows(csv, count)
        (0...count).map { csv.shift }
      end
    end

    private

    def combine(headers)
      headers.each_with_object([]) do |header, combined|
        header.each_with_index do |key, index|
          next if combined[index].nil? && key.nil?
          combined[index] = [combined[index], key]
            .compact
            .join(@config.header_separator)
        end
      end
    end

    def expand(headers)
      return headers unless @config.expand_headers
      headers.map do |header|
        last = nil
        header.map do |key|
          key ? last = key : last
        end
      end
    end

    def unique(combined)
      combined = combined.dup
      collate(combined).each do |key, indexes|
        next if indexes.size == 1
        indexes.each_with_index do |index, count|
          combined[index] = [key, count].join(@config.header_separator)
        end
      end
      combined
    end

    def collate(header)
      collated = {}
      header.each_with_index do |key, index|
        collated[key] = (collated[key] || []) << index
      end
      collated
    end

    def normalize(headers)
      headers.map do |header|
        header.map do |key|
          normalize_key(key)
        end
      end
    end

    def normalize_key(key)
      normalize_headers = @config.normalize_headers
      separator = normalize_headers.is_a?(String) ? normalize_headers : '_'

      key = key.gsub(/[^a-z0-9\-_]+/i, separator)
      unless separator.empty?
        escaped_separator = Regexp.escape(separator)
        key.gsub!(/#{escaped_separator}{2,}/, separator)
        key.gsub!(/^#{escaped_separator}|#{escaped_separator}$/, '')
      end
      key.downcase
    end

    def square(headers)
      length = headers.map(&:size).max
      headers.map { |h| h.fill(nil, h.size, length - h.size) }
    end
  end
end
