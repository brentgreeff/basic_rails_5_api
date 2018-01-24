RSpec.describe "Events" do
  let(:secret_key) { Rails.application.secrets.secret_key_base }

  def generate_token(user)
    JWT.encode({
      user_id: user.id,
      exp: 24.hours.from_now.to_i
      },
      secret_key
    )
  end

  def auth(user)
    { 'Authorization' => generate_token(user) }
  end

  let(:organiser) { create(:organiser) }

  # INDEX
  context 'an event with this organiser' do
    let!(:event) { create(:event, organiser: organiser) }

    context 'and an event, organised by someone else' do
      let!(:another_event) { create(:event) }

      context 'Requesting all events #index' do
        before { get '/events', headers: auth(organiser) }

        it 'returns just the one event' do
          expect( json.count ).to eq 1
          expect( json.first['organiser']['id'] ).to eq organiser.id
        end
      end
    end

    context 'Requesting all events #index' do
      before { get '/events', headers: auth(organiser) }

      it 'returns 200' do
        expect( response ).to have_http_status(200)
      end

      it 'returns the event info' do
        expect( json.first['name'] ).to eq 'My Birthday Party'
        expect( json.first['id'] ).to eq event.id
      end

      it 'returns the group info' do
        expect( json.first['group'] ).to be_kind_of Hash
        expect( json.first['group']['name'] ).to eq 'FB Sucks'
      end
    end

    it_behaves_like 'an action that requires authorization' do
      let(:action) { 'get#events' }
      let(:params) { {} }
    end
  end

  # CREATE
  it "saves the Event" do
    expect {
      post '/events', params: {event: event}, headers: auth(organiser)
    }.to change(Event, :count).by(1)
  end

  it "saves a group" do
    expect {
      post '/events', params: {event: event}, headers: auth(organiser)
    }.to change(Group, :count).by(1)
  end

  it 'adds users as members of the group' do
    expect {
      post '/events', params: {event: event}, headers: auth(organiser)
    }.to change(GroupUser, :count).by(2)
  end

  let(:guest1) { create(:user) }
  let(:guest2) { create(:user) }

  def event
    attributes_for(:event).merge({
      group_attributes: {
        name: 'Only Cool Dudes',
        group_users_attributes: [
          {user_id: guest1.to_param},
          {user_id: guest2.to_param},
        ]
      }
    })
  end

  context '#Creating an Event' do
    before { post '/events', params: {event: event}, headers: auth(organiser) }

    it 'creates an event' do
      expect( json ).to match ({
        'id' => be_kind_of(Integer),
        'name' => event[:name],
        'location' => event[:location],
        'starting' => '2017-10-17',
        'ending' => '2017-10-22',
        'published' => nil,
        'duration' => be_kind_of(Integer),
        'created_at' => match(date_like),
        'updated_at' => match(date_like),
        'deleted_at' => nil,
        'description' => event[:description],
        'group' => {
          'name' => 'Only Cool Dudes'
        },
        'organiser' => be_kind_of(Hash)
      })

      expect( json['organiser']['id'] ).to eq organiser.id
    end

    def date_like
      %r{\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z}
    end

    it 'returns 201' do
      expect( response ).to have_http_status(201)
    end

    it 'calculates the duration' do
      expect( json['duration'] ).to eq 6
    end
  end

  describe '#Creating' do

    it_behaves_like 'an action that requires authorization' do
      let(:action) { 'post#events' }
      let(:params) { {event: event} }
    end
  end

  context 'An invalid Event' do
    before { post '/events', params: {event: invalid}, headers: auth(organiser) }

    def invalid
      attributes_for(:event).merge(
        published: true,
        name: '',
        group_attributes: {
          name: 'Only Cool Dudes'
        }
      )
    end

    it 'returns 422' do
      expect( response ).to have_http_status(422)
    end

    it 'returns validation failed' do
      expect( response.body )
        .to match(/Validation failed: Name can't be blank/)
    end
  end

  # UPDATE
  context '#Updating an Event' do
    let(:event) { create(:event, organiser: organiser) }

    def ev
      {
        name: 'New Name',
        starting: '2017-10-18',
        ending: '2017-11-18'
      }
    end

    context 'that exists' do
      before { patch "/events/#{event.to_param}", params: {event: ev}, headers: auth(organiser) }

      it 'returns 204' do
        expect( response ).to have_http_status(204)
      end

      it 'updates the name' do
        expect( event.reload.name ).to eq 'New Name'
      end

      it 'should update the duration' do
        expect( event.reload.duration ).to eq 32
      end
    end

    it_behaves_like 'an action that requires authorization' do
      let(:action) { "patch#events/#{event.to_param}" }
      let(:params) { {event: ev} }
    end

    context 'that does not exist' do
      before { patch "/events/0", params: {event: ev}, headers: auth(organiser) }

      it 'returns not found' do
        expect(response).to have_http_status(404)
        expect(
          response.body
        ).to match /Couldn't find Event with 'id'=0/
      end
    end

    context 'thats invalid' do
      before { patch "/events/#{event.to_param}", params: {event: invalid}, headers: auth(organiser) }

      def invalid
        attributes_for(:event).merge(
          published: true,
          description: ''
        )
      end

      it 'errors' do
        expect( response ).to have_http_status(422)
        expect( response.body )
          .to match(/Validation failed: Description can't be blank/)
      end
    end

    context 'by a different user' do
      before { patch "/events/#{event.to_param}", params: {event: ev}, headers: auth(create(:someone_else)) }

      it 'is not found' do
        expect( response ).to have_http_status(404)
      end
    end

    context 'with a new group name' do
      before { patch "/events/#{event.to_param}", params: {event: new_group_name}, headers: auth(organiser) }

      def new_group_name
        attributes_for(:event).merge(
          group_attributes: {
            id: event.group.id,
            name: 'New name'
          }
        )
      end

      it 'has new group name' do
        expect( event.reload.group.name ).to eq 'New name'
      end
    end
  end

  # DELETE
  describe '#Destroying an Event' do
    let(:event) { create(:event, organiser: organiser) }

    before { delete "/events/#{event.to_param}", headers: auth(organiser) }

    it 'returns status code 204' do
      expect( response ).to have_http_status(204)
    end

    it 'deletes the event' do
      expect( Event.count ).to eq 0
    end

    it 'is not really deleted' do
      expect( event.reload.deleted_at ).to be
    end
  end

  describe '#Destroying' do
    let(:event) { create(:event, organiser: organiser) }

    context 'by a different user' do
      before { delete "/events/#{event.to_param}", headers: auth(create(:someone_else)) }

      it 'is not found' do
        expect( response ).to have_http_status(404)
      end
    end

    it_behaves_like 'an action that requires authorization' do
      let(:action) { "delete#events/#{event.to_param}" }
      let(:params) { {} }
    end
  end
end
