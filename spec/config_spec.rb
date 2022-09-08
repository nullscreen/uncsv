# frozen_string_literal: true

RSpec.describe Uncsv::Config do
  it 'has defaults' do
    config = described_class.new
    expect(config.skip_blanks).to be(false)
  end

  it 'can set options on initialize' do
    config = described_class.new(skip_blanks: true)
    expect(config.skip_blanks).to be(true)
    expect(config.header_separator).to eq('.')
  end

  it 'sets skipped rows as a hash' do
    config = described_class.new(skip_rows: [1, 4])
    expect(config.skip_rows).to eq(1 => true, 4 => true)
  end

  it 'allows array header rows' do
    config = described_class.new(header_rows: [3, 4])
    expect(config.header_rows).to eq([3, 4])
  end

  it 'allows non-array header rows' do
    config = described_class.new(header_rows: 3)
    expect(config.header_rows).to eq([3])
  end

  it 'gets CSV options' do
    config = described_class.new(col_sep: "\t")
    expect(config.csv_opts).to eq(
      col_sep: "\t",
      field_size_limit: nil,
      quote_char: '"',
      row_sep: :auto
    )
  end

  it 'gets empty expand_headers if false' do
    config = described_class.new(expand_headers: false)
    expect(config.expand_headers).to eq([])
  end

  it 'gets all expand_headers if false' do
    config = described_class.new(header_rows: [1, 2], expand_headers: true)
    expect(config.expand_headers).to eq([1, 2])
  end

  it 'gets partial expand_headers' do
    config = described_class.new(header_rows: [1, 2], expand_headers: 2)
    expect(config.expand_headers).to eq([2])
  end

  it 'can set normalize_headers with a hash' do
    config = described_class.new(
      normalize_headers: { separator: '$', downcase: false }
    )
    expect(config.normalize_headers.separator).to eq('$')
  end

  it 'can set normalize_headers with a custom object' do
    custom_normalizer = Object.new
    config = described_class.new(normalize_headers: custom_normalizer)
    expect(config.normalize_headers).to be(custom_normalizer)
  end

  it 'can set normalize_headers with a boolean' do
    config = described_class.new(normalize_headers: true)
    expect(config.normalize_headers.separator).to eq('_')
  end

  it 'can set normalize_headers with a separator' do
    config = described_class.new(normalize_headers: '%')
    expect(config.normalize_headers.separator).to eq('%')
  end
end
