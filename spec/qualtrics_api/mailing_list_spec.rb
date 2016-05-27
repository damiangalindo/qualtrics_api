require 'spec_helper'

describe QualtricsApi::MailingList, :vcr => true  do
  it 'has a name' do
    name = 'New MailingList'
    mailing_list = QualtricsApi::MailingList.new({
      name: name
    })
    expect(mailing_list.name).to eq(name)
  end

  it 'has a library id' do
    library_id = '1'
    mailing_list = QualtricsApi::MailingList.new({
      library_id: library_id
    })
    expect(mailing_list.library_id).to eq(library_id)
  end

  it 'defaults to the configured library id when none is specified' do
    mailing_list = QualtricsApi::MailingList.new
    expect(mailing_list.library_id).to eq(QualtricsApi.configuration.default_library_id)
  end

  let(:mailing_list) do
    QualtricsApi::MailingList.new({
      name: 'Newest MailingList'
    })
  end

  context 'creating to qualtrics' do
    it 'persists to qualtrics' do
      expect(mailing_list.save).to be true
    end

    it 'populates the panel_id when successful' do
      mailing_list.save
      expect(mailing_list.id).to_not be_nil
    end

    it 'populates the success attribute' do
      mailing_list.save
      expect(mailing_list).to be_success
    end
  end

  it 'raises an error when you attempt to save an already presisted mailing_list' do
    mailing_list.name = 'An Even Newer Panel'
    expect(mailing_list.save).to be true
    mailing_list.name = 'The new newest mailing_list.'
    expect(lambda{ mailing_list.save }).to raise_error QualtricsApi::UpdateNotAllowed
  end

  it 'destroys a mailing_list that returns true when successful' do
    mailing_list.save
    expect(mailing_list.destroy).to be true
  end
end
