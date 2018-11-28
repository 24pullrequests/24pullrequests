object @user
extends 'users/_user'
child :pull_requests do
  extends 'contributions/show'
end
