require 'rails_helper'

RSpec.describe "GroupEvents", type: :request do

  context 'Requesting all events :index' do
    before { get '/group_events' }

    it 'should return 200' do
      expect( response ).to have_http_status(200)
    end
  end

  context 'Creating an Event' do
    before { post '/group_events', params: event }

    def event
      {
        name: 'My Birthday Party',
        location: 'Amirandes Grecotel Exclusive Resort',
        starting: '2017-10-17',
        ending: '2017-10-22',
        description: desc
      }
    end

    def desc
      <<-DESC
        # Pool Party for my Birthday

        Make sure you bring a gift.

        [I will be there](https://www.rsvp.com)
      DESC
    end

    it 'should create an event' do
      event = GroupEvent.first

      expect( json ).to match ({
        'id' => be_kind_of(Integer),
        'name' => 'My Birthday Party',
        'location' => 'Amirandes Grecotel Exclusive Resort',
        'starting' => '2017-10-17',
        'ending' => '2017-10-22',
        'published' => nil,
        'duration' => be_kind_of(Integer),
        'created_at' => match(date_like),
        'updated_at' => match(date_like),
        'description' => desc
      })
    end

    it 'should return 201' do
      expect(response).to have_http_status(201)
    end

    it 'should calculate the duration' do
      expect( json['duration'] ).to eq 5
    end
  end

  def date_like
    %r{\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z}
  end
end
