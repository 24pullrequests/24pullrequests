module EmojiHelper
 def emojify(content)
    images = YAML::load(File.open("#{Rails.root}/config/emoji.yml"))
    content.gsub(/:([a-z0-9\+\-_]+):/) do |match|
      if emoji = images.include?($1)
        "<img title=\"#{$1}\" alt=\"#{$1}\" height=\"20\" src=\"#{images[$1]}\" style=\"vertical-align:middle\" width=\"20\" />"
      else
        match
      end
    end if content.present?
  end
end
