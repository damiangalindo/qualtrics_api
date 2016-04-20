require 'spec_helper'

describe QualtricsApi::DivisionUser, :vcr => true  do

  let(:division) do
    QualtricsApi::Division.new({
      name: 'Division Test'
      })
  end

  let(:division_user) do
    QualtricsApi::DivisionUser.new({
      username: 'division_user@test.com',
      password: '123456',
      firstname: 'Division',
      lastname: 'User',
      type: 'UT_3dBUKOs5wAT2mLW',
      division_id: division.id
      })
  end

  it 'has a username' do
    division.save
    expect(division_user.username).to eq('division_user@test.com')
  end

  it 'has a user_password' do
    division.save
    expect(division_user.password).to eq('123456')
  end

  it 'has a first_name' do
    division.save
    expect(division_user.firstname).to eq('Division')
  end

  it 'has a last_name' do
    division.save
    expect(division_user.lastname).to eq('User')
  end

  it 'has a type' do
    division.save
    expect(division_user.type).to eq('UT_3dBUKOs5wAT2mLW')
  end

  it 'has a division_id' do
    division.save
    expect(division_user.division_id).to eq(division.id)
  end

  context 'creating to qualtrics' do
    it 'populates the division_user id when successful' do
      division.save
      division_user.save

      expect(division_user.id).to_not be_nil
    end
  end

end
