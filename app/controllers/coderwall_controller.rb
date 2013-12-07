class CoderwallController < ApplicationController
  def authorize
    username = params["user"]["coderwall_username"]
    
    begin
      coderwall_respons = ActiveSupport::JSON.decode(open("https://coderwall.com/#{username}.json").read)

      if current_user.nickname == coderwall_respons["accounts"]["github"]
        current_user.change_coderwall_username!(username)
      else
        flash[:notice] = "The user #{username} has not the same github account connecte with coderwall."
        #show error message githubacount need to be conected with coderwall and need to be the same as on 24pullrequest
      end
    rescue Exception => e
      flash[:notice] = "No user found with this name."
    end
    
    flash[:notice] = "Successfully update your coderwall username!" if flash[:notice].nil?
      
    puts "current_user coderwall username #{current_user.coderwall_username}"
    redirect_to :back
  end
end