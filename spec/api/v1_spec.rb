# frozen_string_literal: true

describe Api::V1, type: :routes do
  context 'GET /api/v1' do
    it 'returns version of api' do
      get '/api/v1'

      expect(last_response.status).to eq(200)
      expect(response_body['version']).to eq 'v1'
    end
  end

  context 'POST /api/v1/users' do
    context 'with invalid params' do
      let(:params) { { user: { name: '', email: '2', password: '3' } }.to_json }
      let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
      let(:request) { post '/api/v1/users', params, headers }

      it 'does not create user' do
        expect { request }.not_to change(User, :count)
      end

      context 'in response' do
        before { request }

        it 'returns error status' do
          expect(last_response.status).to eq(400)
        end

        it 'and returns error' do
          expect(response_body['errors']).not_to eq nil
        end
      end
    end

    context 'with valid params' do
      let(:params) { { user: { name: 'Name', email: 'email@gmail.com', password: '1234QWER' } }.to_json }
      let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
      let(:request) { post '/api/v1/users', params, headers }

      it 'creates user' do
        expect { request }.to change { User.count }.by(1)
      end

      context 'in response' do
        before { request }

        it 'returns success status' do
          expect(last_response.status).to eq(201)
        end

        it 'and returns success message' do
          expect(response_body['result']).to eq 'User is created'
        end
      end
    end
  end

  context 'POST /api/v1/sessions' do
    context 'with invalid params' do
      let(:params) { { email: '2', password: '3' }.to_json }
      let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
      let(:request) { post '/api/v1/sessions', params, headers }

      it 'does not create user session' do
        expect { request }.not_to change(UserSession, :count)
      end

      context 'in response' do
        before { request }

        it 'returns error status' do
          expect(last_response.status).to eq(400)
        end

        it 'and returns error' do
          expect(response_body['errors']).not_to eq nil
        end
      end
    end

    context 'with invalid params for existed user' do
      let(:user) { create :user }
      let(:params) { { email: user.email, password: '3' }.to_json }
      let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
      let(:request) { post '/api/v1/sessions', params, headers }

      it 'does not create user session' do
        expect { request }.not_to change(UserSession, :count)
      end

      context 'in response' do
        before { request }

        it 'returns error status' do
          expect(last_response.status).to eq(400)
        end

        it 'and returns error' do
          expect(response_body['errors']).not_to eq nil
        end
      end
    end

    context 'with valid params' do
      let(:password) { '1234QWER' }
      let(:user) { create :user, password: password }
      let(:params) { { email: user.email, password: password }.to_json }
      let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
      let(:request) { post '/api/v1/sessions', params, headers }

      it 'creates user session' do
        expect { request }.to change { UserSession.count }.by(1)
      end

      context 'in response' do
        before { request }

        it 'returns success status' do
          expect(last_response.status).to eq(201)
        end

        it 'and returns token' do
          expect(response_body['token']).not_to eq nil
        end
      end
    end
  end

  context 'GET /api/v1/verify_token' do
    let(:token) { JwtEncoder.encode(uuid: session_uuid) }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:request) { get "/api/v1/verify_token?token=#{token}", {}, headers }

    before { request }

    context 'with invalid params' do
      let(:session_uuid) { 'invalid' }

      it 'returns error status' do
        expect(last_response.status).to eq(403)
      end

      it 'and returns error' do
        expect(response_body['errors']).not_to eq nil
      end
    end

    context 'with valid params' do
      let(:user_session) { create :user_session }
      let(:session_uuid) { user_session.uuid }

      it 'returns success status' do
        expect(last_response.status).to eq(200)
      end

      it 'and returns user_id' do
        expect(response_body['user_id']).to eq user_session.user.id
      end
    end
  end
end
