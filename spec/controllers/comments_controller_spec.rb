require 'rails_helper'
 RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:comment) { create(:comment, commentable: question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do

      it 'saves a new user comment in database' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(user.comments, :count).by(1)
      end

      it 'saves a new question comment in database' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(question.comments, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do

      it 'does not save the comment' do
        expect { post :create, params: { comment: attributes_for(:invalid_comment), question_id: question }, format: :js }.to_not change(question.comments, :count)
      end

      it 'render create template' do
        post :create, params: { comment: attributes_for(:invalid_comment), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end
end
