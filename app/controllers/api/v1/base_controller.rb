class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  skip_before_action :verify_authenticity_token

  respond_to :json

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end
