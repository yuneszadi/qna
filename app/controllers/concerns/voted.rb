module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_entity, only: [:like, :dislike ]
  end

  def like
    @vote = @entity.like(current_user)

    respond_to do |format|
      format.json { render json: { id: @entity.id, rating: @entity.rating } }
    end
  end

  def dislike
    @vote = @entity.dislike(current_user)

    respond_to do |format|
      format.json { render json: { id: @entity.id, rating: @entity.rating } }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_entity
    @entity = model_klass.find(params[:id])
  end
end
