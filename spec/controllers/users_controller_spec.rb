require 'test_helper'

RSpec.describe UsersController, type: :controller do
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

  describe 'teacher?' do
    let(:student) { create(:student) }

    before do
      sign_in(student.user)
      get :index
    end

    it 'should return error' do
      expect(response.status).to eq(401)
      JSON.parse(response.body).tap do |json|
        expect(json['error_message']).to eq('Not teacher')
      end
    end
  end

  describe '#index' do
    context 'when teacher retrieves users' do
      let!(:student) { create(:student) }

      before do
        sign_in(teacher.user)
        get :index
      end

      it 'validate json schema' do
        expect(response).to match_response_schema('user/index')
      end

      it 'validates response' do
        JSON.parse(response.body).tap do |json|
          expect(json['records'].length).to eq(2)
        end
      end
    end
  end

  describe '#show' do
    context 'when teacher retrieves user detail' do
      let(:student) { create(:student) }

      before do
        sign_in(teacher.user)
        get :show, params: {
          id: student.user.id
        }
      end

      it 'validate json schema' do
        expect(response).to match_response_schema('user/show')
      end

      it 'validates response' do
        JSON.parse(response.body).tap do |json|
          expect(json['record']['name']).to eq(student.user.name)
        end
      end
    end

    context 'when user does not exists' do
      let(:student) { create(:student) }

      before do
        sign_in(teacher.user)
        get :show, params: {
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

  describe '#create' do
    context 'when teacher create successfully new user' do
      before do
        sign_in(teacher.user)
        post :create, params: {
          name: 'Cuong',
          email: 'cuong@example.com',
          password: '12345678',
          role: 'Student'
        }
      end

      it 'should return user' do
        JSON.parse(response.body).tap do |json|
          expect(json['record']['name']).to eq('Cuong')
          expect(json['record']['role']).to eq('Student')
        end
      end
    end

    context 'when invalid params role' do
      before do
        sign_in(teacher.user)
        post :create, params: {
          name: 'Cuong',
          email: 'cuong@example.com',
          password: '12345678',
          role: 'ABC'
        }
      end

      it 'should return invalid role error' do
        JSON.parse(response.body).tap do |json|
          expect(json['error_message']).to eq('invalid role')
        end
      end
    end

    context 'when missing params email' do
      before do
        sign_in(teacher.user)
        post :create, params: {
          name: 'Cuong',
          password: '12345678',
          role: 'Student'
        }
      end

      it 'should return invalid role error' do
        JSON.parse(response.body).tap do |json|
          expect(json['error_message']['email'].first).to eq("can't be blank")
        end
      end
    end
  end

  describe '#update' do
    let!(:student) { create(:student) }

    context 'when teacher update successfully new user' do
      before do
        sign_in(teacher.user)
        put :update, params: {
          id: student.user.id,
          name: 'Not Cuong Anymore',
          email: 'cuong@example.com',
          password: '12345678',
          role: 'Teacher'
        }
      end

      it 'should return user' do
        JSON.parse(response.body).tap do |json|
          expect(json['record']['name']).to eq('Not Cuong Anymore')
          expect(json['record']['role']).to eq('Teacher')
        end
      end
    end

    context 'when invalid params role' do
      before do
        sign_in(teacher.user)
        put :update, params: {
          id: student.user.id,
          name: 'Cuong',
          email: 'cuong@example.com',
          password: '12345678',
          role: 'ABC'
        }
      end

      it 'should return invalid role error' do
        JSON.parse(response.body).tap do |json|
          expect(json['error_message']).to eq('invalid role')
        end
      end
    end
  end

  describe '#destroy' do
    let!(:student) { create(:student) }

    context 'when teacher destroy successfully new user' do
      before do
        sign_in(teacher.user)
        delete :destroy, params: {
          id: student.user.id
        }
      end

      it 'should return success' do
        JSON.parse(response.body).tap do |json|
          expect(json['success']).to eq true
        end
      end
    end

    context 'when user does not exists' do
      let(:student) { create(:student) }

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
