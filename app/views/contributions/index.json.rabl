collection @pull_requests

extends 'contributions/show'
child :user do
  extends 'users/_user'
end
