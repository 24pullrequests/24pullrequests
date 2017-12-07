module ApplicationHelper
  def escape_language(lang)
    url_encode(lang.downcase) if lang
  end

  def parameterize_language(lang)
    lang.gsub(/\+/, 'p').gsub(/\#/, 'sharp').parameterize if lang
  end

  def language_link(language, label = nil)
    language = if language.respond_to? :map
                 language.map(&method(:escape_language))
               else
                 escape_language language
               end
    label ||= [language].flatten.join(', ')
    link_to label, '#', data: { language: language }
  end

  def github_button(nickname)
    %(<iframe src="http://ghbtns.com/github-btn.html?user=#{nickname}&type=follow&count=true" allowtransparency="true" frameborder="0" scrolling="0" width="300" height="20"></iframe>).html_safe
  end

  def contributors_in(year)
    PullRequest.year(year).load.map(&:user_id).uniq.length
  end

  def pull_requests_in(year)
    PullRequest.year(year).count
  end

  def projects_in(year)
    PullRequest.year(year).select(:repo_name).map(&:repo_name).uniq.count
  end

  def current_path(locale = nil)
    path = request.env['REQUEST_PATH']
    path += "?locale=#{locale}" if locale.present?
    path
  end

  def available_locales
    %w(en es el pt_br fi fr de ru uk th it nb ta tr zh_Hans zh_Hant ja cs hi)
  end

  def current_translations
    @translations ||= I18n.backend.send(:translations)
    @translations[I18n.locale].with_indifferent_access
  end

  def twitter_url
    'http://twitter.com/24pullrequests'
  end

  def unconfirmed_email?
    logged_in? && current_user.unconfirmed?
  end
end