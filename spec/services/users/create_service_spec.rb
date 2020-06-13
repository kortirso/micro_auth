# frozen_string_literal: true

RSpec.describe Users::CreateService do
  subject { described_class }

  context 'with valid parameters' do
    let(:user_params) do
      {
        user: {
          name:     'User',
          email:    'user@gmail.com',
          password: '1234QWER'
        }
      }
    end

    it 'creates a new user' do
      expect { subject.call(user_params) }.to change { User.count }.from(0).to(1)
    end

    it 'and assigns user' do
      result = subject.call(user_params)

      expect(result.result).to be_kind_of(User)
    end
  end

  context 'with invalid parameters' do
    context 'with existed user' do
      let!(:user) { create :user }
      let(:invalid_user_params) do
        {
          user: {
            name:     'User',
            email:    user.email,
            password: ''
          }
        }
      end

      it 'does not create user' do
        expect { subject.call(invalid_user_params) }.not_to change(User, :count)
      end

      it 'and returns nil as user' do
        result = subject.call(invalid_user_params)

        expect(result.result).to eq nil
      end
    end

    context 'with invalid empty password' do
      let(:invalid_user_params) do
        {
          user: {
            name:     'User',
            email:    'user@gmail.com',
            password: ''
          }
        }
      end

      it 'does not create user' do
        expect { subject.call(invalid_user_params) }.not_to change(User, :count)
      end

      it 'and returns nil as user' do
        result = subject.call(invalid_user_params)

        expect(result.result).to eq nil
      end
    end

    context 'with invalid short password' do
      let(:invalid_user_params) do
        {
          user: {
            name:     'User',
            email:    'user@gmail.com',
            password: '1234'
          }
        }
      end

      it 'does not create user' do
        expect { subject.call(invalid_user_params) }.not_to change(User, :count)
      end

      it 'and returns nil as user' do
        result = subject.call(invalid_user_params)

        expect(result.result).to eq nil
      end
    end
  end
end
