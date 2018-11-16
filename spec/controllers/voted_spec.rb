require 'rails_helper'

shared_examples_for 'voted' do
  let(:controller) { described_class }
  let(:resource) { create(controller.to_s.underscore.split('_')[0].singularize.to_sym) }
  let!(:user) { create(:user) }

  before { sign_in(user) }

  describe 'PATCH #like' do
    it 'saves a new resource vote in the database' do
      expect { patch :like, params: { id: resource.id, format: :json } }.to change(resource.votes, :count).by(1)
    end

    it 'gets success json response' do
      expect(response.status).to eq 200
      expect(response.body).to eq "{\"id\":#{resource.id},\"rating\":1}"
    end
  end

  describe 'PATCH #dislike' do
    it 'saves a new resource\'s vote in the database' do
      expect { patch :dislike, params: { id: resource.id, format: :json } }.to change(resource.votes, :count).by(1)
    end

    it 'gets success json response' do
      expect(response.status).to eq 200
      expect(response.body).to eq "{\"id\":#{resource.id},\"rating\":-1}"
    end
  end
end
