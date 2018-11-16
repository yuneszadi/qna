require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:resource) { create(model.to_s.underscore.to_sym) }

  describe '#like' do
    it 'should like resource' do
      expect { resource.like(user) }.to change(resource.votes, :count).by(1)
    end

    it 'should change rating of resource' do
      resource.like(user)
      expect(resource.rating).to eq 1
    end

    it 'should dont like resource if user has already voted' do
      resource.like(user)
      expect { resource.like(user) }.to_not change(resource.votes, :count)
    end

    it 'should dont add vote to resource if user is an author' do
      expect { resource.like(resource.user) }.to_not change(resource.votes, :count)
    end
  end

  describe '#dislike' do
    it 'should dislike resource' do
      expect { resource.dislike(user) }.to change(resource.votes, :count).by(1)
    end

    it 'should change rating of resource' do
      resource.dislike(user)
      expect(resource.rating).to eq -1
    end

    it 'should dont add vote to resource if user has already voted' do
      resource.dislike(user)
      expect { resource.dislike(user) }.to_not change(resource.votes, :count)
    end

    it 'should dont add vote to resource if user is an author' do
      expect { resource.dislike(resource.user) }.to_not change(resource.votes, :count)
    end
  end
end
