class Users::RegistrationsController < Devise::RegistrationsController
  def new
    resource = build_resource({})
    respond_with resource
  end
end