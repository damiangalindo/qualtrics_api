require 'spec_helper'

describe QualtricsApi::Survey, :vcr => true  do

  it 'has a survey id' do
    survey_id = 'SV_id'
    survey = QualtricsApi::Survey.new({
      id: survey_id
    })
    expect(survey.id).to eq(survey_id)
  end

  it 'has a survey name' do
    survey_name = 'Best survey for Kevin'
    survey = QualtricsApi::Survey.new({
      survey_name: survey_name
    })
    expect(survey.survey_name).to eq(survey_name)
  end
  
  it 'returns the correct survey status' do
    survey_status = true
    survey = QualtricsApi::Survey.new({
      is_active: survey_status
    })
    expect(survey.status).to eq('Active')
  end

  it 'has a survey owner id and creator id' do
    survey_owner_id = 'something'
    creator_id = 'something else'

    survey = QualtricsApi::Survey.new({
      survey_owner_id: survey_owner_id,
      creator_id: creator_id
    })

    expect(survey.survey_owner_id).to eq(survey_owner_id)
    expect(survey.creator_id).to eq(creator_id)
  end

  it 'has a number of responses' do
    responses = 10
    survey = QualtricsApi::Survey.new({
      responses: responses
    })
    expect(survey.responses).to eq(responses)
  end

  it 'has various date attributes' do
    survey_start_date = '0000-00-00 00:00:00'
    survey_expiration_date = '2014-10-02 18:03:12'
    survey_creation_date = '2014-10-02 18:03:13'
    last_modified = '2014-10-02 18:03:14'
    last_activated = '2014-10-02 18:03:15'

    survey = QualtricsApi::Survey.new({
      survey_start_date: survey_start_date,
      survey_expiration_date: survey_expiration_date,
      survey_creation_date: survey_creation_date,
      last_modified: last_modified,
      last_activated: last_activated
    })

    expect(survey.survey_start_date).to eq(survey_start_date)
    expect(survey.survey_expiration_date).to eq(survey_expiration_date)
    expect(survey.survey_creation_date).to eq(survey_creation_date)
    expect(survey.last_modified).to eq(last_modified)
    expect(survey.last_activated).to eq(last_activated)
  end  

  # ##TODO get QualtricsApi transaction to rollback survey creation

  context 'creating to QualtricsApi' do

    let(:survey_import) do
      QualtricsApi::SurveyImport.new({
        survey_name: 'Complex survey',
        survey_data_url: 'http://welltok-assessment-development.s3.amazonaws.com/uploads/survey/questions_file/9/Testing_one_more_time.qsf'
      })
    end

    let(:survey) { survey_import.survey }

    it 'destroys a survey that returns true when successful' do
      survey_import.save
      expect(survey.destroy).to be true
    end

    it 'populates the survey_id when successful' do
      survey_import.save

      expect(survey.id).to_not be_nil
      survey.destroy
    end

    it 'retrieves an array with the first 10 surveys' do
      survey_import.save

      expect(QualtricsApi::Survey.paginated_response.map{|p| p.id}).to include(survey.id)
      survey.destroy
    end

    it 'retrieves the correct survey providing the id' do
      survey_import.save

      expect(QualtricsApi::Survey.find(survey.id).survey_name).to eql('Complex survey')

      survey.destroy
    end

    it 'can be activated or deactivated' do
      survey_import.save
      expect(survey.activate).to be true
      expect(survey.deactivate).to be true
      survey.destroy
    end

    it 'returns the survey status Active/Inactive' do
      survey_import.save

      expect(survey.activate).to be true
      expect(survey.deactivate).to be true
      expect(survey.status) == 'Inactive'
      survey.destroy
    end

  end

  context 'generating response export' do
    let(:survey_import) do
      QualtricsApi::SurveyImport.new({
        survey_name: 'Complex survey',
        survey_data_url: 'http://welltok-assessment-development.s3.amazonaws.com/uploads/survey/questions_file/9/Testing_one_more_time.qsf'
      })
    end

    let(:survey) { survey_import.survey }

    before(:each) do
      survey_import.save
      survey
    end

    it 'generates a response export and returns the export Id' do
      expect(survey.generate_response_export(DateTime.now - 1.day, DateTime.now)).to match /ES_.+/

      survey.destroy
    end

    it 'returns a zip file with the responses in a json file' do
      stub_request(:get, 'https://co1.qualtrics.com/API/v3/responseexports/ES_rt5a9i8p401qpp7p1ohdp6rnom/file').to_return(body: IO.binread(File.dirname(__FILE__)+'/../fixtures/response_data_ES_rt5a9i8p401qpp7p1ohdp6rnom.zip'))

      expect(survey.retrieve_response_data('ES_rt5a9i8p401qpp7p1ohdp6rnom').class).to be Array

      survey.destroy
    end
  end

end
