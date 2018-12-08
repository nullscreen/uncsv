# Uncsv

[![Build Status](https://travis-ci.org/machinima/uncsv.svg?branch=master)](https://travis-ci.org/machinima/uncsv)
[![Code Climate](https://codeclimate.com/github/machinima/uncsv/badges/gpa.svg)](https://codeclimate.com/github/machinima/uncsv)
[![Test Coverage](https://codeclimate.com/github/machinima/uncsv/badges/coverage.svg)](https://codeclimate.com/github/machinima/uncsv)

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
  heirarchical headers where not all the header cells are filled in. If set to
  an array of header indexes, only the specified headers will be expanded.
- `:header_rows`: Default `[]`. Can be set to either a single row index or an
  array of row indexes. For example, it could be set to `0` to indicate a
  header in the first row. If set to an array of indexes (`[1,2]`), the header
  row text will be joined by the `:header_separator`. For example, if if the
  cell (0,0) had the value `"Personal"` and cell (1,0) had the value "Name",
  the header would become `"Personal.Name"`. Any data above the last header row
  will be ignored.
- `:header_separator`: Default `"."`. When using multiple header rows, this is
  a string used to separate the individual header fields.
- `:nil_empty`: Default `true`. If `true`, empty cells will be set to `nil`,
  otherwise, they are set to an empty string.
- `:normalize_headers`: Default `false`. If set to `true`, header field text
  will be normalized. The text will be lowercased, and non-alphanumeric
  characters will be replaced with underscores (`_`). If set to a string,
  those characters will be replaced with the string instead. If set to a hash,
  the hash will be treated as options to KeyNormalizer, accepting the
  `:separator`, and `:downcase` options. If set to another object, it is
  expected to respond to the `normalize(key)` method by returning a normalized
  string.
- `:skip_blanks`: Default `false`. If `true`, rows whose fields are all empty
  will be skipped.
- `:skip_rows`: Default `[]`. If set to an array of row indexes, those rows
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
- `:field_size_limit`
- `:quote_char`
- `:row_sep`
- `:skip_blanks`

## Development

After checking out the repo, run `bundle` to install dependencies. You
can also run `bin/console` for an interactive prompt that will allow you to
experiment.

To check your work, run `bin/rake` to check code style and run the tests. To
generate a code coverage report, set the `COVERAGE` environment variable when
running the tests.

```sh
COVERAGE=1 bin/rake
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/machinima/uncsv.

## License

Copyright 2018 Warner Bros. Entertainment Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
