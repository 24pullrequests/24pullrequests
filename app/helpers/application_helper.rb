module ApplicationHelper
  def parameterize_language(lang)
    lang.gsub(/\+/, 'p')
        .gsub(/\#/, 'sharp')
        .parameterize
  end

  def gravatar_url(digest, size = '80')
    digest ||= ''
    "https://secure.gravatar.com/avatar/#{digest}.png?s=#{size}&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"
  end
end
