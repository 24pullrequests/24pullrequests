class UnsubscribesController < ApplicationController
  def new; end

  def create
    @user = User.find_by_login(unsubscribe_params[:login])
    @user&.unsubscribe!
    flash[:notice] = t('unsubscribe.success')
    redirect_to root_path
  end

  private

  def unsubscribe_params
    params.require(:unsubscribe).permit(:login)
  end
end
