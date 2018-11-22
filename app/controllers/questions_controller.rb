class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [ :update, :new, :create, :update ]
  before_action :find_question, only: [ :show, :edit, :update, :destroy ]
  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: "Your question successfully created."
    else
      render :new, notice: 'Your question was not created.'
    end
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end


  def destroy
    @question.destroy if current_user.author_of?(@question)
    redirect_to questions_path
  end

  private

  def find_question
    @question = Question.find(params[:id])
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :destroy])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions', ApplicationController.render(
      partial: 'questions/collection_item', locals: { question: @question }, layout: false
    )
  end
end
