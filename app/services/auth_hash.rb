class AuthHash
  def self.extract_user_info(hash)
    AuthHash.new(hash).user_info
  end

  def initialize(user_hash)
    @user_hash = user_hash
  end

  def user_info
    {
      :provider => provider,
      :token => token,
      :uid => uid,
      :nickname => nickname,
      :email => email,
      :gravatar_id => gravatar_id
    }
  end

  private

  def user_hash
    @user_hash
  end

  def provider
    puts user_hash.inspect
    user_hash.fetch('provider')
  end

  def uid
    user_hash.fetch('uid')
  end

  def nickname
    user_hash.fetch('info',{}).fetch('nickname')
  end

  def email
    user_hash.fetch('info',{}).fetch('email', nil)
  end

  def gravatar_id
    user_hash.fetch('extra',{}).fetch('raw_info',{}).fetch('gravatar_id', nil)
  end

  def token
    user_hash.fetch('credentials', {}).fetch('token')
  end

end
