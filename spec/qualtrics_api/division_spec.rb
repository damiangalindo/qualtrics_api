require 'spec_helper'

describe QualtricsApi::Division, :vcr => true  do

  it 'has a division name' do
    division_name = 'Divison_name'
    division = QualtricsApi::Division.new({
      name: division_name
    })
    expect(division.name).to eq(division_name)
  end

  context 'creating to qualtrics' do

    let(:division) do
      QualtricsApi::Division.new({
        name: 'Division Test'
      })
    end

    it 'populates the division_id when successful' do
      division.save

      expect(division.id).to_not be_nil
    end

    it 'updates a division status on qualtrics' do
      division.save

      expect(division.update({'status' => 'Disabled'})).to be true
    end

    it 'updates a division name on qualtrics' do
      division.save

      expect(division.update({'name' => 'Updated Division'})).to be true
    end
  end

end
