require 'uncsv/version'
require 'uncsv/config'
require 'uncsv/header'
require 'uncsv/rows'
require 'csv'

class Uncsv
  include Enumerable

  def initialize(csv, opts = {})
    @config = Config.new(opts)
    yield @config if block_given?
    @csv = CSV.new(csv, @config.csv_opts)
  end

  def self.open(filename, opts = {}, &block)
    new(File.open(filename, 'rb'), opts, &block)
  end

  def each(&block)
    rows.each(&block)
  end

  def header
    rows.header
  end

  private

  def rows
    @rows ||= Rows.new(@csv, @config)
  end
end
