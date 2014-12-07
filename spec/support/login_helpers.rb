module LoginHelpers
  def mock_twitter_auth
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      :info => {
        :nickname => Faker::Lorem.word
      },
      :credentials => {
        :token => SecureRandom.hex,
        :secret => SecureRandom.hex
      }
    )
  end

  def mock_is_admin(admin = false)
    allow_any_instance_of(User).to receive(:is_admin?).and_return(admin)
  end

  def mock_github_auth(user)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      :provider => 'github',
      :uid => user.uid,
      :info => {
        :nickname => user.nickname,
        :email => user.email
      },
      :extra => {
        :raw_info => {
          :gravatar_id => user.gravatar_id
        }
      },
      :credentials => {
        :token => user.token
      }
    )
  end

  def login(user)
    mock_github_auth(user)
    visit login_path
  end
end

RSpec.configure do |config|
  config.include LoginHelpers
end
