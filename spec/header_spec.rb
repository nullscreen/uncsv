RSpec.describe Uncsv::Header do
  it 'parses a first-row header' do
    csv = CSV.new('this,is,a,test')
    config = Uncsv::Config.new(header_rows: 0)
    header = described_class.parse!(csv, config).header
    expect(header.to_a).to eq(%w(this is a test))
  end

  it 'parses a header in the third row' do
    csv = CSV.new("\n\nthis,is,a,test")
    config = Uncsv::Config.new(header_rows: 2)
    header = described_class.parse!(csv, config).header
    expect(header.to_a).to eq(%w(this is a test))
  end

  it 'parses and combines multiple headers' do
    csv = CSV.new("foo,,bar,\n\nthis,is,a,test")
    config = Uncsv::Config.new(header_rows: [0, 2])
    header = described_class.parse!(csv, config).header
    expect(header.to_a).to eq(%w(foo.this is bar.a test))
  end

  it 'parses when no header rows' do
    csv = CSV.new('foo,bar')
    config = Uncsv::Config.new
    header = described_class.parse!(csv, config).header
    expect(header.to_a).to eq([])
  end

  it 'leaves the file pointer after the last header row when parsing' do
    csv = CSV.new("foo,,bar,\n\nthis,is,a,test\nmy,data,goes,here")
    config = Uncsv::Config.new(header_rows: [0, 2])
    described_class.parse!(csv, config)
    expect(csv.shift).to eq(%w(my data goes here))
  end

  it 'can get an Enumerable' do
    csv = CSV.new('foo,bar')
    config = Uncsv::Config.new(header_rows: 0)
    header = described_class.parse!(csv, config).header
    expect(header.each.to_a).to eq(%w(foo bar))
  end

  it 'can be iterated over with each' do
    csv = CSV.new('foo,bar')
    config = Uncsv::Config.new(header_rows: 0)
    header = described_class.parse!(csv, config).header
    array = []
    header.each do |key|
      array << key
    end
    expect(array).to eq(%w(foo bar))
  end

  it 'can expand over blank header fields' do
    csv = CSV.new("foo,,bar,\nthis,is,a,test")
    config = Uncsv::Config.new(header_rows: [0, 1], expand_headers: true)
    header = described_class.parse!(csv, config).header
    expect(header.to_a).to eq(%w(foo.this foo.is bar.a bar.test))
  end

  it 'uniques duplicate header names' do
    csv = CSV.new("foo,,bar,\na,b,b,b")
    config = Uncsv::Config.new(
      header_rows: [0, 1],
      unique_headers: true,
      expand_headers: true
    )
    header = described_class.parse!(csv, config).header
    expect(header.to_a).to eq(%w(foo.a foo.b bar.b.0 bar.b.1))
  end

  it 'ignores conflicts when uniqueing' do
    csv = CSV.new("foo,,bar,,\na,b,b,b,b.0")
    config = Uncsv::Config.new(
      header_rows: [0, 1],
      unique_headers: true,
      expand_headers: true
    )
    header = described_class.parse!(csv, config).header
    expect(header.to_a).to eq(%w(foo.a foo.b bar.b.0 bar.b.1 bar.b.0))
  end

  it 'normalizes header keys' do
    csv = CSV.new('"Has spaces",has.dot')
    config = Uncsv::Config.new(header_rows: 0, normalize_headers: true)
    header = described_class.parse!(csv, config).header
    expect(header.to_a).to eq(%w(has_spaces has_dot))
  end

  it 'returns current row index' do
    csv = CSV.new("\n\nthis,is,a,test")
    config = Uncsv::Config.new(header_rows: 2)
    parsed = described_class.parse!(csv, config)
    expect(parsed.index).to eq(3)
  end
end
