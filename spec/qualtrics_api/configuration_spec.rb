require 'spec_helper'

describe QualtricsApi::Configuration do
  it 'has a version' do
    version = '3.0'
    configuration = QualtricsApi::Configuration.new do |config|
      config.version = version
    end
    expect(configuration.version).to eq(version)
  end

  it 'defaults to latest version' do
    configuration = QualtricsApi::Configuration.new
    expect(configuration.version).to eq(QualtricsApi::Configuration::DEFAULT_VERSION)
  end

  it 'has a token' do
    token = '12341234'
    configuration = QualtricsApi::Configuration.new do |config|
      config.token = token
    end
    expect(configuration.token).to eq(token)
  end

  it 'has an endpoint' do
    endpoint = 'https://co1.qualtricsApi.com/WRAPI/ControlPanel/api.php'
    configuration = QualtricsApi::Configuration.new do |config|
      config.endpoint = endpoint
    end
    expect(configuration.endpoint).to eq(endpoint)
  end

  it 'has a default endpoint' do
    configuration = QualtricsApi::Configuration.new
    expect(configuration.endpoint).to eq(QualtricsApi::Configuration::DEFAULT_ENDPOINT)
  end

  it 'has an organization' do
    organization = 'brand'
    configuration = QualtricsApi::Configuration.new do |config|
      config.organization = organization
    end
    expect(configuration.organization).to eq(organization)
  end
end