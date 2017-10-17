require 'rails_helper'

RSpec.describe GroupEvent, type: :model do

  # Published
  context 'when the event is published' do
    context 'and has no name' do
      let(:event) { with_no :name }

      it 'should be invalid' do
        expect( event ).not_to be_valid
      end
    end

    context 'and has no location' do
      let(:event) { with_no :location }

      it 'should be invalid' do
        expect( event ).not_to be_valid
      end
    end

    context 'and has no starting date' do
      let(:event) { with_no :starting }

      it 'should be invalid' do
        expect( event ).not_to be_valid
      end
    end

    context 'and has no ending date' do
      let(:event) { with_no :ending }

      it 'should be invalid' do
        expect( event ).not_to be_valid
      end
    end

    context 'and has no description' do
      let(:event) { with_no :description }

      it 'should be invalid' do
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

      it 'should be valid' do
        expect( event ).to be_valid
      end
    end

    context 'and has no location' do
      let(:event) { with_no :location }

      it 'should be valid' do
        expect( event ).to be_valid
      end
    end

    context 'and has no starting date' do
      let(:event) { with_no :starting }

      it 'should be valid' do
        expect( event ).to be_valid
      end
    end

    context 'and has no ending date' do
      let(:event) { with_no :ending }

      it 'should be valid' do
        expect( event ).to be_valid
      end
    end

    context 'and has no description' do
      let(:event) { with_no :description }

      it 'should be valid' do
        expect( event ).to be_valid
      end
    end

    def with_no(field)
      params = {published: false}
      build :group_event, params.merge(field => '')
    end
  end
end
