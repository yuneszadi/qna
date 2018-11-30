require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Forbidden' }
      format.js { head :forbidden }
      format.json { head :forbidden }
    end
  end

  before_action :gon_user

   private

   def gon_user
    gon.user_id = current_user.id if current_user
  end
end
