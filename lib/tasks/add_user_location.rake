desc 'Geocode location for existing users'
task geocode_existing_users: :environment  do
  User.where.not(location: nil).each do |user|
    if user.lat.nil? || user.lng.nil?
      user.save
    end
  end
end
