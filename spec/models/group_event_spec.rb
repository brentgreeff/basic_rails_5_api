RSpec.describe GroupEvent, type: :model do

  # @assumption - the start and end date are inclusive.
  context 'An existing event' do
    let(:event) do
      create(:group_event,
        starting: '2017-10-10', ending: '2017-10-11')
    end

    context 'updating the ending to blank' do
      before { event.ending = '' }

      it 'should not calculate the duration' do
        event.save!
        expect( event.duration ).to eq 2
      end
    end

    context 'updating the starting to blank' do
      before { event.starting = '' }

      it 'should not calculate the duration' do
        event.save!
        expect( event.duration ).to eq 2
      end
    end
  end

  # Published
  context 'when the event is published' do
    context 'and has no name' do
      let(:event) { with_no :name }

      it 'is invalid' do
        expect( event ).not_to be_valid
      end
    end

    context 'and has no location' do
      let(:event) { with_no :location }

      it 'is invalid' do
        expect( event ).not_to be_valid
      end
    end

    context 'and has no starting date' do
      let(:event) { with_no :starting }

      it 'is invalid' do
        expect( event ).not_to be_valid
      end
    end

    context 'and has no ending date' do
      let(:event) { with_no :ending }

      it 'is invalid' do
        expect( event ).not_to be_valid
      end
    end

    context 'and has no description' do
      let(:event) { with_no :description }

      it 'is invalid' do
        expect( event ).not_to be_valid
      end
    end

    def with_no(field)
      params = {published: true}
      build :group_event, params.merge(field => '')
    end
  end

  # Not published
  context 'when the event is NOT published' do
    context 'and has no name' do
      let(:event) { with_no :name }

      it 'is valid' do
        expect( event ).to be_valid
      end
    end

    context 'and has no location' do
      let(:event) { with_no :location }

      it 'is valid' do
        expect( event ).to be_valid
      end
    end

    context 'and has no starting date' do
      let(:event) { with_no :starting }

      it 'is valid' do
        expect( event ).to be_valid
      end
    end

    context 'and has no ending date' do
      let(:event) { with_no :ending }

      it 'is valid' do
        expect( event ).to be_valid
      end
    end

    context 'and has no description' do
      let(:event) { with_no :description }

      it 'is valid' do
        expect( event ).to be_valid
      end
    end

    def with_no(field)
      params = {published: false}
      build :group_event, params.merge(field => '')
    end
  end
end
