require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let(:non_author) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { question.answers.new(body: "Answer's body") }

  before { sign_in(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new Answer in the database' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'link Answer with current user' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(user.answers, :count).by(1)
      end

      it 'redirect to "question/show"' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new Answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js }.to_not change(Answer, :count)
      end

      it 'render "question/show" template' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { question.answers.create(body: "Answer Title", user: user) }

    context 'for author' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(user.answers, :count).by(-1)
      end
    end

    context 'for non-author' do
      let(:non_author) { create(:user) }

      before { sign_in(non_author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js  }.to_not change(Answer, :count)
      end

      it 'redirect to question/show' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question, user: user) }

    context 'author of answer' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new_body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new_body'
      end

      it 'render "update" template' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Not author of answer' do
      before { sign_in(non_author) }

      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'not changes answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new_body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new_body'
      end

      it 'render "update" template' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end
