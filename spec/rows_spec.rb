RSpec.describe Uncsv::Rows do
  it 'outputs data rows' do
    csv = CSV.new("1,2\n3,4")
    rows = described_class.new(csv, Uncsv::Config.new)
    expect(rows.each.map(&:fields)).to eq([%w(1 2), %w(3 4)])
  end

  it 'outputs rows with headers' do
    csv = CSV.new("foo,bar\n1,2\n3,4")
    rows = described_class.new(csv, Uncsv::Config.new(header_rows: 0))
    expect(rows.each.map { |r| r['foo'] }).to eq(%w(1 3))
  end

  it 'skips blank rows' do
    csv = CSV.new("1,2\n\n3,4")
    rows = described_class.new(csv, Uncsv::Config.new(skip_blanks: true))
    expect(rows.each.map(&:fields)).to eq([%w(1 2), %w(3 4)])
  end

  it 'skips rows by index' do
    csv = CSV.new("foo,bar\n1,2\n3,4\n5,6\n7,8")
    config = Uncsv::Config.new(skip_rows: [2, 4], header_rows: 0)
    rows = described_class.new(csv, config)
    expect(rows.each.map(&:fields)).to eq([%w(1 2), %w(5 6)])
  end
end
