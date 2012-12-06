collection @pull_requests

extends 'pull_requests/show'
child :user do
  extends 'users/_user'
end
