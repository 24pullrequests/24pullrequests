class Project < ActiveRecord::Base
  attr_accessible :description, :github_url, :name, :main_language

  validates_presence_of :description, :github_url, :name, :main_language
  validates_format_of :github_url, :with => /^https?:\/\/(www\.)?github.com\/[\w-]*\/[\w-]*(\/)?$/i, :message => 'Enter the full HTTP URL.'
  validates_uniqueness_of :github_url, :message => "Project has already been suggested."
  validates_length_of :description, :within => 20..200
  validate :main_language_available?, :message => " can not add this language"

  LANGUAGES = ["ActionScript", "Assembly", "C", "C#", "C++", "Clojure", "CoffeeScript",
               "ColdFusion", "CSS", "Emacs Lisp", "Erlang", "Haskell", "HTML", "Java", "JavaScript", 
               "Lua", "Objective-C", "Perl", "PHP", "PowerShell", "Python", "Ruby",
               "Scala", "Scheme", "Shell"]

  def github_repository
    self.github_url.gsub(/^(((https|http|git)?:\/\/(www\.)?)|git@)github.com(:|\/)/i, '').gsub(/(\.git|\/)$/i, '')
  end

  def main_language_available?
    unless LANGUAGES.include?(self.main_language)
      errors.add(:main_language, ' must be a programming language')
    end
  end

end
