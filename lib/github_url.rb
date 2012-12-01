module GithubUrl

  # Accepts the following formats:
  # https://github.com/user/repo
  # http://github.com/user/repo
  # user/repo
  # git@github.com:user/repo.git
  def self.normalize(url)
    m = /\A(https?\:\/\/|git@)?(github\.com[:\/])?(?<username>[a-zA-Z_-]*)\/(?<repo>[a-zA-Z_-]*)/.match(url)
    return url unless m

    "https://github.com/#{m[:username]}/#{m[:repo]}"
  end
end
