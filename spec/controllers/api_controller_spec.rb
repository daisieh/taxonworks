require 'rails_helper'

describe ApiController, type: :controller do
  # before(:each) {
  #   sign_in
  # }

  shared_examples_for 'successful response' do
    it 'returns HTTP Status 200 OK' do
      expect(response).to be_success
    end

    it 'returns JSON object indicating success' do
      expect(JSON.parse(response.body)).to eq('success' => true)
    end
  end

  shared_examples_for 'unauthorized response' do
    it 'returns HTTP Status 401 Unauthorized' do
      expect(response).to be_unauthorized
    end

    it 'returns JSON object indicating failure' do
      expect(JSON.parse(response.body)).to eq('success' => false)
    end
  end

  context 'when token is valid' do
    let(:user) { FactoryGirl.create(:valid_user, :user_valid_token) }
    let(:params) { {project_id: 1, format: :json} }

    context 'when provided in header' do
      before do
        @request.headers['Authorization'] = 'Token token=' + user.api_access_token
        get :index, params: params
      end

      it_behaves_like 'successful response'
    end

    context 'when provided in query params' do
      before { get :index, params: {token: user.api_access_token}.merge(params) }

      it_behaves_like 'successful response'
    end

    context 'when project_id is missing' do
      before { get :index, token: user.api_access_token }

      it 'returns HTTP Status 400 Bad Request' do
        expect(response).to be_bad_request
      end

      it 'returns JSON object indicating failure' do
        expect(JSON.parse(response.body)).to eq('success' => false)
      end
    end
  end

  context 'when token is invalid' do
    let(:user) { FactoryGirl.create(:valid_user, :user_valid_token) }
    let(:params) { {format: :json} }

    context 'when provided in header' do
      before do
        @request.headers['Authorization'] = 'Token token=FOO'
        get :index, params: params
      end

      it_behaves_like 'unauthorized response'
    end

    context 'when provided in query params' do
      before { get :index, params: {token: 'foo'}.merge(params) }

      it_behaves_like 'unauthorized response'
    end

    context 'when not provided' do
      before { get :index, params: params }

      it_behaves_like 'unauthorized response'
    end
  end
end
