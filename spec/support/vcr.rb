require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<QUALTRICS_USER>') { ENV['QUALTRICS_USER'] }
  c.filter_sensitive_data('<QUALTRICS_TOKEN>') { ENV['QUALTRICS_TOKEN'] }
  c.filter_sensitive_data('<QUALTRICS_ORGANIZATION>') { ENV['QUALTRICS_ORGANIZATION'] }
  c.default_cassette_options = { record: :new_episodes, decode_compressed_response: true }
end
