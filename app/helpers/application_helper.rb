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
    %(<iframe src="https://ghbtns.com/github-btn.html?user=#{nickname}&type=follow&count=true" allowtransparency="true" frameborder="0" scrolling="0" width="300" height="20"></iframe>).html_safe
  end

  def contributors_in(year)
    Contribution.year(year).load.map(&:user_id).uniq.length
  end

  def contributions_in(year)
    Contribution.year(year).count
  end

  def projects_in(year)
    Contribution.year(year).select(:repo_name).map(&:repo_name).uniq.count
  end

  def current_path(locale = nil)
    path = request.env['REQUEST_PATH']
    path += "?locale=#{locale}" if locale.present?
    path
  end

  def available_locales
    %w(en es el pt_br fi fr de ru uk th it nb ta tr zh_Hans zh_Hant ja cs hi pl)
  end

  def current_translations
    @translations ||= I18n.backend.send(:translations)
    @translations[I18n.locale].with_indifferent_access
  end

  def mastodon_url
    'https://mastodon.social/@24pullrequests'
  end

  def unconfirmed_email?
    logged_in? && current_user.unconfirmed?
  end

  def format_markdown(str)
    return '' if str.blank?
    # Filter out GitHub comments (HTML comments) from PR descriptions
    filtered_str = str.gsub(/<!--.*?-->/m, '')
    # Also filter out quoted text which is often used in PR templates
    filtered_str = filtered_str.gsub(/^>.+?$\n?/m, '')
    # Then render the markdown and apply other transformations (without UNSAFE flag for security)
    rendered_html = CommonMarker.render_html(filtered_str, [:GITHUB_PRE_LANG], [:tagfilter, :autolink, :table, :strikethrough])
    # Convert newlines to <br> tags for better readability, but avoid adding them at the end
    rendered_html = rendered_html.gsub(/\n(?!<\/(p|li|ul|ol|h1|h2|h3|h4|h5|h6|blockquote|pre|table|tr|th|td)>)(?!$)/, '<br>')
    
    # Use Rails sanitize with explicit allowed tags and attributes for security
    # Define specific allowed protocols for links to prevent javascript: URLs
    sanitize(rendered_html, 
             tags: %w(p br a ul ol li strong em h1 h2 h3 h4 h5 h6 blockquote pre code img table th tr td), 
             attributes: {
               'a' => %w(href title),
               'img' => %w(src alt title),
               'table' => %w(class),
               'all' => %w(class)
             },
             protocols: {
               'a' => {'href' => ['http', 'https', 'mailto']},
               'img' => {'src' => ['http', 'https']}
             })
  end
end
