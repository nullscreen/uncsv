# Uncsv

A parser for unruly CSVs

Parse CSVs with heirarchical headers and duplicated headers. Skip lines by line
number, etc.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uncsv'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install uncsv
```

## Usage

Reading a CSV with Uncsv is similar to using Ruby's built-in CSV class. Create
a new instance of `Uncsv` and pass it a `String` or `IO`. The second argument
is an options hash, see below.

```ruby
require 'uncsv'

data = "A,B,C\n1,2,3"
csv = Uncsv.new(data, header_rows: 0)
csv.map do { |row| row['B'] }
```

### Opening a File

Uncsv can read directly from the filesystem with the `open` method.

```ruby
Uncsv.open('my_data.csv')
```

### Enumerable Methods

Uncsv is an `Enumerable`. All enumerable methods like `each`, `map`, `reduce`,
etc. are supported.

```ruby
data = "A,B,C\n1,2,3\n4,5,6"
csv = Uncsv.new(data, header_rows: 0)
c_total = csv.reduce do { |sum, row| sum + row['C'] }
```

### Options

The following options can be passed as a hash to the second argument of the
Uncsv constructor, or set inside the constructor block.

```ruby
Uncsv.new(data, skip_blanks: true)

# Is equivalent to
Uncsv.new(data) do |config|
  config.skip_blanks = true
end
```

#### Uncsv Options

- `:expand_headers`: Default `false`. If set to `true`, blank header row cells
  will assume the header of the row to their left. This is useful for
  heirarchical headers where not all the header cells are filled in.
- `:header_rows`: Default `[]`. Can be set to either a single row index or an
  array of row indexes. For example, it could be set to `0` to indicate a
  header in the first row. If set to an array of indexes (`[1,2]`), the header
  row text will be joined by the `:header_separator`. For example, if if the
  cell (0,0) had the value `"Personal"` and cell (1,0) had the value "Name",
  the header would become `"Personal.Name"`. Any data above the last header row
  will be ignored.
- `:header_separator`: Default `"."`. When using multiple header rows, this is
  a string used to separate the individual header fields.
- `:normalize_headers`: Default `false`. If set to `true`, header field text
  will be normalized. The text will be lowercased, and non-alphanumeric
  characters will be replaced with underscores (`_`). If set to a string,
  those characters will be replaced with the string instead.
- `:skip_lines`: Default `[]`. If set to an array of row indexes, those rows
  will be skipped. This option does not apply to header rows.
- `:unique_headers`: Default `false`. If set to `true`, headers will be forced
  to be unique by appending numbers to duplicates. For example, if two header
  cells have the text `"Name"`, the headers will become `"Name.0"`, and
  `"Name.1"`. The separator between the text and the number can be set using
  the `:header_separator` option.

#### Options from Std-lib CSV

See the documentation for Ruby's built-in `CSV` class for the following
options.

- `:col_sep`
- `:converters`
- `:field_size_limit`
- `:quote_char`
- `:row_sep`
- `:skip_blanks`

## Development

After checking out the repo, run `bundle` to install dependencies. You
can also run `bin/console` for an interactive prompt that will allow you to
experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/machinima/uncsv.
