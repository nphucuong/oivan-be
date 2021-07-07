require 'test_helper'

RSpec.describe TestsController, type: :controller do
  let(:teacher) { create(:teacher) }

  describe 'authenticate_user' do
    before do
      get :index
    end

    it 'should return error' do
      expect(response.status).to eq(401)
      JSON.parse(response.body).tap do |json|
        expect(json['error']).to eq('Please login!')
      end
    end
  end

  describe '#index' do
    context 'when teacher retrieves tests' do
      let(:test) { create(:test) }
      let(:question) { create(:question, test: test) }
      let!(:answer) { create(:answer, question: question) }

      before do
        sign_in(teacher.user)
        get :index
      end

      it 'validate json schema' do
        expect(response).to match_response_schema('test/index')
      end

      it 'validates response' do
        JSON.parse(response.body).tap do |json|
          expect(json['records'].length).to eq(1)
        end
      end
    end
  end

  describe '#show' do
    context 'when teacher retrieves tests' do
      let(:test) { create(:test) }
      let(:question) { create(:question, test: test) }
      let!(:answer) { create(:answer, question: question) }

      before do
        sign_in(teacher.user)
        get :show, params: {
          id: test.id
        }
      end

      it 'validate json schema' do
        expect(response).to match_response_schema('test/show')
      end

      it 'validates response' do
        JSON.parse(response.body).tap do |json|
          expect(json['record']['name']).to eq(test.name)
          expect(json['record']['questions'][0]['label']).to eq(question.label)
          expect(json['record']['questions'][0]['answers'][0]['answer_content']).to eq(answer.answer_content)
        end
      end
    end
  end
end
