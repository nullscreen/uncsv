# frozen_string_literal: true

RSpec.describe Uncsv do
  it 'can be created from a string' do
    csv = described_class.new('foo,bar')
    expect(csv.to_a.map(&:fields)).to eq([%w[foo bar]])
  end

  it 'can be created from an IO object' do
    csv = described_class.new(StringIO.new('ding,dong'))
    expect(csv.to_a.map(&:fields)).to eq([%w[ding dong]])
  end

  it 'can open a file' do
    File.write('/csv', 'this,is,a,test')
    csv = described_class.open('/csv')
    expect(csv.to_a.map(&:fields)).to eq([%w[this is a test]])
  end

  it 'can iterate over rows via each' do
    csv = described_class.new("hello,world\ngoodbye,world")
    rows = []
    csv.each { |r| rows << r }
    expect(rows.map(&:fields)).to eq([%w[hello world], %w[goodbye world]])
  end

  it 'can get an Enumerable' do
    csv = described_class.new("baa,baa,black,sheep\nyes,three,bags,full")
    enum = csv.each
    expect(enum).to be_instance_of(Enumerator)
    expect(enum.map(&:fields))
      .to eq([%w[baa baa black sheep], %w[yes three bags full]])
  end

  it 'can be configured via a hash' do
    csv = described_class.new("im,a,teapot\nshort,and,stout", header_rows: 0)
    expect(csv.to_a.first['teapot']).to eq('stout')
  end

  it 'can be configured via block' do
    csv = described_class.new("humpty,dumpty\nsat,on,a,wall") do |config|
      config.header_rows = 0
    end
    expect(csv.to_a.first['humpty']).to eq('sat')
  end

  it 'uses CSV parser options' do
    csv = described_class.new("jack\tand\tjill\nwent\tup\thill") do |config|
      config.header_rows = 0
      config.col_sep = "\t"
    end
    expect(csv.to_a.first['jill']).to eq('hill')
  end

  it 'can map to a CSV column' do
    csv = described_class.new("A,B\n1,2", header_rows: 0)
    expect(csv.map { |r| r['B'] }).to eq(['2'])
  end

  it 'can get the header' do
    csv = described_class.new("Z,Y\n1,2", header_rows: 0)
    expect(csv.header).to eq(%w[Z Y])
    expect(csv.to_a.map(&:fields)).to eq([%w[1 2]])
  end

  it 'treats quoted strings as empty' do
    csv = described_class.new(%("","test"\n"foo","bar"), header_rows: [0, 1])
    expect(csv.header).to eq(%w[foo test.bar])
  end
end
