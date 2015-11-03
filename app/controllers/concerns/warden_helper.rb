module WardenHelper
  extend ActiveSupport::Concern

  included do
    # see https://github.com/plataformatec/devise/pull/3732/files
    if respond_to?(:helper_method)
      helper_method :warden, :current_user
    end
    prepend_before_action :authenticate!
  end

  def current_user
    warden.user
  end

  def warden
    request.env['warden']
  end

  def authenticate!
    warden.authenticate!
  end
end
