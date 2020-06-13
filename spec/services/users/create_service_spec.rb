# frozen_string_literal: true

RSpec.describe Users::CreateService do
  subject { described_class }

  context 'with valid parameters' do
    it 'creates a new user' do
      expect { subject.call('bob', 'bob@example.com', 'givemeatoken') }
        .to change { User.count }.from(0).to(1)
    end

    it 'and assigns user' do
      result = subject.call('bob', 'bob@example.com', 'givemeatoken')

      expect(result.user).to be_kind_of(User)
    end
  end

  context 'with invalid parameters' do
    context 'with existed user' do
      let!(:user) { create :user }

      it 'does not create user' do
        expect { subject.call('bob', user.email, '') }
          .not_to change(User, :count)
      end

      it 'and returns nil as user' do
        result = subject.call('bob', user.email, '')

        expect(result.user).to eq nil
      end
    end

    context 'with invalid empty password' do
      it 'does not create user' do
        expect { subject.call('bob', 'bob@example.com', '') }
          .not_to change(User, :count)
      end

      it 'and returns nil as user' do
        result = subject.call('bob', 'bob@example.com', '')

        expect(result.user).to eq nil
      end
    end

    context 'with invalid short password' do
      it 'does not create user' do
        expect { subject.call('bob', 'bob@example.com', '1') }
          .not_to change(User, :count)
      end

      it 'and returns nil as user' do
        result = subject.call('bob', 'bob@example.com', '1')

        expect(result.user).to eq nil
      end
    end
  end
end
