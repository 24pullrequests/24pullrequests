module ApplicationHelper
  def parameterize_language(lang)
    lang.gsub(/\+/, 'p')
        .gsub(/\#/, 'sharp')
        .parameterize
  end

  def language_link(language, label=nil)
    language = if language.respond_to? :map
      language.map &method(:parameterize_language)
    else
      parameterize_language language
    end
    label = label || [language].flatten.join(', ')
    link_to label, '#', :data => {:language => language}
  end

  def gravatar_url(digest='', size = '80')
    "https://secure.gravatar.com/avatar/#{digest}.png?s=#{size}&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"
  end

  def github_button(nickname)
    %(<iframe src="http://ghbtns.com/github-btn.html?user=#{nickname}&type=follow&count=true" allowtransparency="true" frameborder="0" scrolling="0" width="300" height="20"></iframe>).html_safe
  end
end
