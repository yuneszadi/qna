require 'rails_helper'
RSpec.describe 'Search class' do
  describe 'search_results' do
    let!(:search_text) { 'text' }

    %w(Users Questions Answers Comments).each do |search_object|
      it "returns results for #{search_object}" do
        expect(search_object.classify.constantize).to receive(:search).with(search_text)
        Search.search_results(search_text, search_object)
      end
    end
  end
end
