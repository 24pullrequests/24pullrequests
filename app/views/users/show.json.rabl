object @user
extends 'users/_user'
child :pull_requests do
  extends 'pull_requests/show'
end
child :archived_pull_requests do
  extends 'pull_requests/show'
end
