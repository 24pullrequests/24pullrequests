class ProfilesController < ApplicationController
  def add_email
    profile = Profile.new(current_user)

    if profile.email_missing?
      render :add_email, :locals => { :profile => profile }
    else
      redirect_to profile_path
    end
  end

  def update
    profile = Profile.new(current_user)

    if profile.update_attributes(post_params)
      flash[:notice] = "Profile updated!"
    else
      flash[:error] = "There was an error updating your profile."
    end

    redirect_to profile_path
  end

  private
  def post_params
    params[:profile].slice(:email)
  end
end
