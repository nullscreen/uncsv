RSpec.describe Uncsv::Row do
  it 'gets a field by header' do
    row = described_class.new(%w(foo bar), %w(my_value other_val))
    expect(row['bar']).to eq('other_val')
  end

  it 'gets a field by index' do
    row = described_class.new(%w(foo bar), %w(my_value other_val))
    expect(row[1]).to eq('other_val')
  end

  it 'squares header with the fields' do
    row = described_class.new(%w(foo bar), %w(my_value other_val third_val))
    expect(row.header).to eq(['foo', 'bar', nil])
  end

  it 'squares fields with the header' do
    row = described_class.new(%w(foo bar baz), %w(my_value))
    expect(row.fields).to eq(['my_value', nil, nil])
  end

  it 'gets a hash' do
    row = described_class.new(%w(foo bar), %w(my_value other_val third_val))
    expect(row.to_h).to eq('foo' => 'my_value', 'bar' => 'other_val')
  end

  it 'fetches with a default value' do
    row = described_class.new(%w(foo bar), %w(my_value other_val))
    expect(row.fetch('baz', 'nuts')).to eq('nuts')
  end

  it 'fetches with a default block' do
    row = described_class.new(%w(foo bar), %w(my_value other_val))
    expect(row.fetch('baz') { |k| k }).to eq('baz')
  end

  it 'gets an Enumerator' do
    row = described_class.new(%w(foo bar), %w(my_value other_val))
    expect(row.each.to_a).to eq([%w(foo my_value), %w(bar other_val)])
  end

  it 'iterates over pairs' do
    row = described_class.new(%w(foo bar), %w(my_value other_val))
    pairs = []
    row.each { |p| pairs << p }
    expect(pairs).to eq([%w(foo my_value), %w(bar other_val)])
  end

  it 'has Enumerable methods' do
    row = described_class.new(%w(foo bar), %w(my_value other_val))
    pairs = row.map { |k, v| "#{k}:#{v}" }
    expect(pairs).to eq(%w(foo:my_value bar:other_val))
  end

  it 'can stringify nils' do
    row = described_class.new(%w(foo bar), %w(my_value))
    expect(row.fields).to eq(['my_value', nil])
  end

  it 'can nilify strings' do
    row = described_class.new(%w(foo), [''], Uncsv::Config.new(nil_empty: true))
    expect(row.fields).to eq([nil])
  end
end
