module ApplicationHelper
  def escape_language(lang)
    url_encode(lang.downcase) if lang
  end

  def parameterize_language(lang)
    if lang
      lang.gsub(/\+/, 'p')
          .gsub(/\#/, 'sharp')
          .parameterize
    end
  end

  def language_link(language, label=nil)
    language = if language.respond_to? :map
      language.map &method(:escape_language)
    else
      escape_language language
    end
    label = label || [language].flatten.join(', ')
    link_to label, '#', data: {language: language}
  end

  def gravatar_url(digest='', size = '80')
    "https://secure.gravatar.com/avatar/#{digest}.png?s=#{size}&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"
  end

  def github_button(nickname)
    %(<iframe src="http://ghbtns.com/github-btn.html?user=#{nickname}&type=follow&count=true" allowtransparency="true" frameborder="0" scrolling="0" width="300" height="20"></iframe>).html_safe
  end

  def gittip_button(nickname)
    %(<a href="https://www.gittip.com/#{nickname}/"><img alt="Support via Gittip" src="https://rawgithub.com/twolfson/gittip-badge/0.1.0/dist/gittip.png"/> </a>).html_safe
  end

  def contributors_in year
    PullRequest.year(year).load.map(&:user_id).uniq.length
  end

  def pull_requests_in year
    PullRequest.year(year).count
  end

  def projects_in year
    PullRequest.year(year).select(:repo_name).map(&:repo_name).uniq.count
  end

  def current_path locale=nil
    path = request.env["REQUEST_PATH"]
    path += "?locale=#{locale}" if locale.present?
    path
  end

  def available_locales
    [ 'en', 'es', 'el', 'pt_br', 'fi', 'fr', 'de', 'ru', 'uk' ]
  end

  def contributing_url type='html'
    url = 'http://24pullrequests.com/contributing'
    return url if type == 'text'
    link_to url, url
  end

  def twitter_url type='html'
    url = 'http://twitter.com/24pullrequests'
    return url if type == 'text'
    link_to url, url
  end

  def preferences_url type='html'
    url = 'http://24pullrequests.com/preferences'
    return url if type == 'text'
    link_to url, url
  end

end
