require 'test_helper'

RSpec.describe StudentTestResultsController, type: :controller do
  let(:student) { create(:student) }

  describe 'authenticate_user' do
    before do
      post :create
    end

    it 'should return error' do
      expect(response.status).to eq(401)
      JSON.parse(response.body).tap do |json|
        expect(json['error']).to eq('Please login!')
      end
    end
  end

  describe 'student?' do
    let(:teacher) { create(:teacher) }

    before do
      sign_in(teacher.user)
      post :create
    end

    it 'should return error' do
      expect(response.status).to eq(401)
      JSON.parse(response.body).tap do |json|
        expect(json['error_message']).to eq('Not student')
      end
    end
  end

  describe '#create' do
    let(:test) { create(:test) }
    let(:question) { create(:question, test: test) }
    let(:question1) { create(:question, test: test) }
    let!(:answer) { create(:answer, question: question, is_true_anwser: true) }
    let!(:answer1) { create(:answer, question: question1, is_true_anwser: false) }
    let!(:answer1_1) { create(:answer, question: question1, is_true_anwser: true) }

    context 'when student submit test' do
      before do
        sign_in(student.user)
        post :create, params: {
          test_id: test.id,
          student_id: student.id,
          result: [answer.id, answer1.id]
        }
      end

      it 'should return success' do
        expect(response.status).to eq(200)
        expect(student.student_test_results.find_by(test_id: test.id).score).to eq 5
      end
    end
  end
end
