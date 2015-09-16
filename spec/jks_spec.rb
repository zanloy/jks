require 'spec_helper'

describe JKS do
  before :all do
    @filename = File.expand_path('fixtures/keystore.jks')
    @jks = JKS.new(@filename, 'password')
  end

  it 'reads in the certs' do
    expect(@jks.certs.count).to eql(1)
  end
end
