class AuthHash
  def self.extract_user_info(hash)
    AuthHash.new(hash).user_info
  end

  def initialize(user_hash)
    @user_hash = user_hash
  end

  def user_info
    {
      provider:    provider,
      token:       token,
      uid:         uid,
      nickname:    nickname,
      email:       email,
      gravatar_id: gravatar_id,
      name:        name,
      blog:        blog,
      location:    location
    }
  end

  private

  attr_reader :user_hash

  def provider
    user_hash.fetch('provider')
  end

  def uid
    user_hash.fetch('uid')
  end

  def nickname
    info.fetch('nickname')
  end

  def email
    info.fetch('email', nil)
  end

  def gravatar_id
    raw_info.fetch('gravatar_id', nil)
  end

  def name
    raw_info.fetch('name', nil)
  end

  def blog
    raw_info.fetch('blog', nil)
  end

  def location
    raw_info.fetch('location', nil)
  end

  def token
    user_hash.fetch('credentials', {}).fetch('token')
  end

  private

  def info
    user_hash.fetch('info', {})
  end

  def raw_info
    user_hash.fetch('extra', {}).fetch('raw_info', {})
  end
end
