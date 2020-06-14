# frozen_string_literal: true

RSpec.describe Auth::FetchUserService do
  subject { described_class }

  context 'for valid token' do
    let(:token) { JwtEncoder.encode(uuid: session_uuid) }

    context 'for unexisted session' do
      let(:session_uuid) { 'random uuid' }

      it 'does not assign user' do
        service = subject.call(token: token)

        expect(service.result).to be_nil
      end
    end

    context 'for existed session' do
      let(:user_session) { create :user_session }
      let(:session_uuid) { user_session.uuid }

      it 'assigns user' do
        service = subject.call(token: token)

        expect(service.result).to eq user_session.user
      end
    end
  end

  context 'for invalid token' do
    let(:service) { subject.call(token: 'random uuid') }

    it 'does not assign user' do
      expect(service.result).to be_nil
    end

    it 'adds an error' do
      expect(service).to be_failure
      expect(service.errors.size).not_to be_nil
    end
  end
end
