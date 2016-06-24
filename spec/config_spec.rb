RSpec.describe Uncsv::Config do
  it 'has defaults' do
    config = described_class.new
    expect(config.skip_blanks).to eq(false)
  end
end
