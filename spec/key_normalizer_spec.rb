# frozen_string_literal: true

RSpec.describe Uncsv::KeyNormalizer do
  it 'converts non-alphanumeric characters to separator' do
    expect(described_class.new.normalize('abc-123$hello,world'))
      .to eq('abc_123_hello_world')
  end

  it 'downcases keys by default' do
    expect(described_class.new.normalize('HI'))
      .to eq('hi')
  end

  it 'deduplicates consecutive separators' do
    expect(described_class.new.normalize('hello$%world'))
      .to eq('hello_world')
  end

  it 'removes front and trailing separators' do
    expect(described_class.new.normalize('*&foo-bar#'))
      .to eq('foo_bar')
  end

  it 'can customize the separator' do
    expect(described_class.new(separator: '$!').normalize('hello--world-'))
      .to eq('hello$!world')
  end

  it 'can pass-through uppercase' do
    expect(described_class.new.normalize('IM YELLING!!!'))
      .to eq('im_yelling')
  end
end
