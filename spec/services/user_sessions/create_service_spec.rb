# frozen_string_literal: true

RSpec.describe UserSessions::CreateService do
  subject { described_class }

  context 'for valid parameters' do
    let(:user_params) { { email: 'bob@example.com', password: 'givemeatoken' } }
    let!(:user) { create(:user, user_params) }

    it 'creates a new session' do
      expect { subject.call(user_params) }.to change { UserSession.where(user_id: user.id).count }.from(0).to(1)
    end

    it 'and assigns session' do
      result = subject.call(user_params)

      expect(result.result).to be_kind_of(UserSession)
    end
  end

  context 'for missing user' do
    let(:user_params) { { email: 'bob@example.com', password: 'givemeatoken' } }

    it 'does not create session' do
      expect { subject.call(user_params) }.not_to change(UserSession, :count)
    end

    it 'and returns nil result' do
      result = subject.call(user_params)

      expect(result.result).to be_nil
    end
  end

  context 'for invalid password' do
    let(:user_params) { { email: 'bob@example.com', password: 'invalid' } }
    let!(:user) { create(:user, email: 'bob@example.com', password: 'givemeatoken') }

    it 'does not create session' do
      expect { subject.call(user_params) }.not_to change(UserSession, :count)
    end

    it 'and returns nil result' do
      result = subject.call(user_params)

      expect(result.result).to be_nil
    end
  end
end
