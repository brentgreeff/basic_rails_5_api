RSpec.describe "Events", type: :request do

  # INDEX
  context 'with an event' do
    let!(:event) { create(:event) }

    context 'Requesting all events :index' do
      before { get '/events' }

      it 'returns 200' do
        expect( response ).to have_http_status(200)
      end

      it 'should return the events' do
        expect( json ).to be_kind_of(Array)
        expect( json.first['name'] ).to eq 'My Birthday Party'
        expect( json.first['id'] ).to eq event.id
      end
    end
  end

  # CREATE
  context 'Creating an Event' do
    before { post '/events', params: event }

    def event
      attributes_for(:event)
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
        'deleted_at' => nil,
        'description' => event[:description]
      })
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

  context 'An invalid Event' do
    before { post '/events', params: invalid }

    def invalid
      attributes_for(:event).merge(
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
    let(:event) { create(:event) }

    def params
      {
        name: 'New Name',
        starting: '2017-10-18',
        ending: '2017-11-18'
      }
    end

    context 'that exists' do
      before { put "/events/#{event.to_param}", params: params }

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

    context 'that does not exist' do
      before { put "/events/0", params: params }

      it 'returns 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found' do
        expect(
          response.body
        ).to match /Couldn't find Event with 'id'=0/
      end
    end

    context 'thats invalid' do
      before { put "/events/#{event.to_param}", params: invalid }

      def invalid
        attributes_for(:event).merge(
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
    let(:event) { create(:event) }

    before { delete "/events/#{event.to_param}" }

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
end
