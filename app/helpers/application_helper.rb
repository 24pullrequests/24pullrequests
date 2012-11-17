module ApplicationHelper
  def parameterize_language(lang)
    lang.gsub(/\+/, 'p')
        .gsub(/\#/, 'sharp')
        .parameterize
  end
end
