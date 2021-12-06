object @user
extends 'users/_user'
node(:pull_requests) { |user| partial('contributions/show', :object => user.contributions) }
