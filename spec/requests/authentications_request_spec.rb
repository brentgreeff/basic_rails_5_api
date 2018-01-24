require 'rails_helper'

RSpec.describe "Authentications", type: :request do

  describe "POST /authentications" do
    let(:user) { create(:user) }

    let(:valid) do
      { email: user.email, password: 'password' }
    end

    let(:app_json) do
      {"Content-Type" => "application/json"}
    end

    context 'logging in' do
      before do
        expect(JWT).to receive(:encode).with(
          {
            user_id: user.id,
            exp: 24.hours.from_now.to_i
          },
          Rails.application.secrets.secret_key_base
        ).and_return 'TOKEN'
      end
      before { post '/login', params: valid.to_json, headers: app_json }

      it 'returns an auth_token' do
        expect( json['auth_token'] ).to eq 'TOKEN'
      end
    end

    context 'An email that does NOT exist' do
      let(:invalid_email) { valid.merge(email: 'does.not.exist@example.com') }

      before { post '/login', params: invalid_email.to_json, headers: app_json }

      it 'should error' do
        expect( response ).to have_http_status(401)
        expect( response.body ).to match /Invalid credentials/
      end
    end

    context 'The wrong password' do
      let(:wrong_pass) { valid.merge(password: 'wrong') }

      before { post '/login', params: wrong_pass.to_json, headers: app_json }

      it 'should error' do
        expect( response ).to have_http_status(401)
        expect( response.body ).to match /Invalid credentials/
      end
    end

    context 'A blank password' do
      let(:blank_pass) { valid.merge(password: '') }

      before { post '/login', params: blank_pass.to_json, headers: app_json }

      it 'should error' do
        expect( response ).to have_http_status(401)
        expect( response.body ).to match /Invalid credentials/
      end
    end
  end
end
