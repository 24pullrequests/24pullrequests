class Profile
  extend Forwardable
  extend ActiveModel::Naming

  def_delegators :@user, :to_key, :email, :to_param, :update_attributes, :email_missing?

  def initialize(user)
    @user = user
  end
end
