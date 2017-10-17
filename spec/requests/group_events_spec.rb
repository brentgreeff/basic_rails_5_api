RSpec.describe "GroupEvents", type: :request do

  context 'Requesting all events :index' do
    before { get '/group_events' }

    it 'returns 200' do
      expect( response ).to have_http_status(200)
    end
  end

  # CREATE
  context 'Creating an Event' do
    before { post '/group_events', params: event }

    def event
      attributes_for(:group_event)
    end

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
        'description' => event[:description]
      })
    end

    it 'returns 201' do
      expect( response ).to have_http_status(201)
    end

    it 'calculates the duration' do
      expect( json['duration'] ).to eq 5
    end
  end

  def date_like
    %r{\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z}
  end

  context 'An invalid Event' do
    before { post '/group_events', params: invalid }

    def invalid
      attributes_for(:group_event).merge(
        published: true,
        name: ''
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
  context 'Updating an Event' do
    let(:event) { create(:group_event) }

    def params
      {name: 'New Name'}
    end

    context 'that exists' do
      before { put "/group_events/#{event.to_param}", params: params }

      it 'returns 204' do
        expect( response ).to have_http_status(204)
      end

      it 'updates the item' do
        expect( event.reload.name ).to eq 'New Name'
      end
    end

    context 'that does not exist' do
      before { put "/group_events/0", params: params }

      it 'returns 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found' do
        expect(
          response.body
        ).to match /Couldn't find GroupEvent with 'id'=0/
      end
    end

    context 'thats invalid' do
      before { put "/group_events/#{event.to_param}", params: invalid }

      def invalid
        attributes_for(:group_event).merge(
          published: true,
          description: ''
        )
      end

      it 'returns 422' do
        expect( response ).to have_http_status(422)
      end

      it 'returns validation failed' do
        expect( response.body )
          .to match(/Validation failed: Description can't be blank/)
      end
    end
  end

  # DELETE
  describe 'Deleting an Event' do
    let(:event) { create(:group_event) }

    before { delete "/group_events/#{event.to_param}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'deletes event' do
      expect( GroupEvent.count ).to eq 0
    end
  end
end
