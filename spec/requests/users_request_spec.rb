require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "POST /users" do

    it 'creates a user' do
      expect {
        post '/users', params: {user: attributes_for(:user)}
      }.to change(User, :count).by(1)
    end

    context '#Creating a user' do
      before { post '/users', params: {user: attributes_for(:user)} }

      it 'returns 201' do
        expect( response ).to have_http_status(201)
        expect( response.body ).to match /Account created/
      end

      let(:saved) { User.first }

      it 'saves the attributes' do
        expect( saved.full_name ).not_to be_blank

        expect( saved.password ).to be_blank
        expect( saved.password_digest ).not_to be_blank

        expect( saved.email ).to match %r{[a-z]+@example\.com}
      end
    end

    context 'without a password' do
      let(:without_password) do
        attributes_for(:user).merge(password: '')
      end
      before { post '/users', params: {user: without_password} }

      it 'returns an error' do
        expect( response ).to have_http_status(422)
        expect( response.body )
          .to match(/Validation failed: Password can't be blank/)
      end
    end

    context 'without a email' do
      let(:without_email) do
        attributes_for(:user).merge(email: '')
      end
      before { post '/users', params: {user: without_email} }

      it 'returns an error' do
        expect( response ).to have_http_status(422)
        expect( response.body )
          .to match(/Validation failed: Email can't be blank/)
      end
    end
  end
end
