require 'test_helper'

RSpec.describe TestsController, type: :controller do
  let(:teacher) { create(:teacher) }
  let(:test) { create(:test) }
  let(:question) { create(:question, test: test) }
  let!(:answer) { create(:answer, question: question) }

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

  describe '#create' do
    context 'when teacher create successfully test' do
      before do
        sign_in(teacher.user)
        post :create, params: {
          name: 'Test',
          description: 'This is test',
          questions: [
            {
              label: 'Question label',
              question_content: 'Question content',
              answers: [
                {
                  answer_content: 'Answer content',
                  is_true_anwser: true
                }
              ]
            }
          ]
        }
      end

      it 'should return test' do
        JSON.parse(response.body).tap do |json|
          expect(json['record']['name']).to eq('Test')
          expect(json['record']['questions'][0]['label']).to eq('Question label')
          expect(json['record']['questions'][0]['answers'][0]['answer_content']).to eq('Answer content')
        end
      end
    end

    context 'when missing label of question params' do
      before do
        sign_in(teacher.user)
        post :create, params: {
          name: 'Test',
          description: 'This is test',
          questions: [
            {
              question_content: 'Question content',
              answers: [
                {
                  answer_content: 'Answer content',
                  is_true_anwser: true
                }
              ]
            }
          ]
        }
      end

      it 'should return error message' do
        JSON.parse(response.body).tap do |json|
          expect(json['error_message']).to eq("Validation failed: Label can't be blank")
        end
      end
    end
  end

  describe '#update' do
    context 'when teacher update successfully test' do
      before do
        sign_in(teacher.user)
        put :update, params: {
          id: test.id,
          name: 'Test',
          description: 'This is test',
          questions: [
            {
              label: 'Question label',
              question_content: 'Question content',
              answers: [
                {
                  answer_content: 'Answer content',
                  is_true_anwser: true
                }
              ]
            }
          ]
        }
      end

      it 'should return test' do
        JSON.parse(response.body).tap do |json|
          expect(json['record']['name']).to eq('Test')
          expect(json['record']['questions'][0]['label']).to eq('Question label')
          expect(json['record']['questions'][0]['answers'][0]['answer_content']).to eq('Answer content')
          expect(json['record']['questions'][0]['answers'].count).to eq(1)
        end
      end
    end

    context 'when missing label of question params' do
      before do
        sign_in(teacher.user)
        put :update, params: {
          id: test.id,
          name: 'Test',
          description: 'This is test',
          questions: [
            {
              question_content: 'Question content',
              answers: [
                {
                  answer_content: 'Answer content',
                  is_true_anwser: true
                }
              ]
            }
          ]
        }
      end

      it 'should return error message' do
        JSON.parse(response.body).tap do |json|
          expect(json['error_message']).to eq("Validation failed: Label can't be blank")
        end
      end
    end
  end

  describe '#show' do
    context 'when teacher retrieves tests' do
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

  describe '#destroy' do
    let!(:student) { create(:student) }

    context 'when teacher destroy successfully test' do
      before do
        sign_in(teacher.user)
        delete :destroy, params: {
          id: test.id
        }
      end

      it 'should return success' do
        JSON.parse(response.body).tap do |json|
          expect(json['success']).to eq true
        end
      end
    end

    context 'when user does not exists' do
      before do
        sign_in(teacher.user)
        delete :destroy, params: {
          id: 999
        }
      end

      it 'should return not found user error' do
        expect(response.status).to eq(404)
        JSON.parse(response.body).tap do |json|
          expect(json['error_message']).to eq('Not found user')
        end
      end
    end
  end
end
