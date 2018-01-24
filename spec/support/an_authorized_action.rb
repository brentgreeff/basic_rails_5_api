shared_examples 'an action that requires authorization' do

  def req
    action.split('#').first
  end

  def url
    "/#{action.split('#').last}"
  end

  context 'and a missing auth token' do
    before { send(req, url, params: params, headers: {'Authorization' => nil}) }

    it 'errors' do
      expect( response ).to have_http_status(401)
      expect( response.body ).to match /Token required/
    end
  end

  context 'wrong auth token' do
    before do
      expect(JWT).to receive(:decode).with('Wrong', secret_key).and_call_original
    end
    before { send(req, url, params: params, headers: {'Authorization' => 'Wrong'}) }

    it 'errors' do
      expect( response ).to have_http_status(401)
      expect( response.body ).to match /Invalid token/
    end
  end
end
