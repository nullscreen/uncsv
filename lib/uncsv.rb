require 'uncsv/version'
require 'uncsv/config'
require 'uncsv/header'
require 'uncsv/rows'
require 'csv'

class Uncsv
  def initialize(csv, opts = {})
    @config = Config.new(opts)
    yield @config if block_given?
    @csv = CSV.new(csv, @config.csv_opts)
  end

  def self.open(filename, opts = {}, &block)
    new(File.open(filename, 'r'), opts, &block)
  end

  def each(&block)
    Rows.new(@csv, @config).each(&block)
  end

  def to_a
    each.to_a
  end
end
