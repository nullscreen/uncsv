require 'uncsv/version'
require 'uncsv/config'
require 'uncsv/key_normalizer'
require 'uncsv/header'
require 'uncsv/row'
require 'uncsv/rows'
require 'csv'
require 'ostruct'

# Parses CSV data and iterates through it
#
# Accepts a `String`, `IO`, or file, and outputs CSV rows. The rows can be
# iterated over with `each`. `Uncsv` is also `Enumerable`, so all of those
# built-in Ruby methods also work with it, including `map`, `reduce`, `select`,
# etc.
class Uncsv
  include Enumerable

  # Create a new `Uncsv` parser
  #
  # @param data [String, IO] The input CSV data to parse
  # @param opts [Hash] A hash of configuration options.
  #   See {Config#initialize}.
  # @yield An optional block for setting configuration options.
  # @yieldparam config [Config] The configuration object.
  def initialize(data, opts = {})
    @config = Config.new(opts)
    yield @config if block_given?
    @csv = CSV.new(data, @config.csv_opts)
  end

  # Create a new `Uncsv` parser from a file
  #
  # @param filename [String] The path of the file to open
  # @param opts (see #initialize)
  # @yield (see #initialize)
  # @yieldparam (see #initialize)
  def self.open(filename, opts = {}, &block)
    new(File.open(filename, 'rb'), opts, &block)
  end

  # Iterate over each data row of the CSV
  #
  # @yield A block to run for each row
  # @yieldparam row [Row] A row object
  # @return [Enumerator] An enumerator over each row
  def each(&block)
    rows.each(&block)
  end

  # Get an array of the headers
  #
  # Ordered from left to right
  #
  # @return [Array] An array of the header rows
  def header
    rows.header
  end

  private

  # Initialize the internal rows object
  #
  # Once initialized, the {Rows} object is cached and reused for
  # consecutive calls to {#each}.
  def rows
    @rows ||= Rows.new(@csv, @config)
  end
end
