class Project < ActiveRecord::Base
  attr_accessible :description, :github_url, :name, :main_language

  validates_presence_of :description, :github_url, :name, :main_language
  validates_uniqueness_of :github_url, :message => "already been submitted"
  validates_length_of :description, :within => 20..200
  validate :main_language_available?, :message => " can not add this language"

  LANGUAGES = ["ActionScript", "Assembly", "C", "C#", "C++", "Clojure", "CoffeeScript",
               "ColdFusion", "CSS", "Emacs Lisp", "Erlang", "Haskell", "HTML", "Java", "JavaScript", 
               "Lua", "Objective-C", "Perl", "PHP", "PowerShell", "Python", "Ruby",
               "Scala", "Scheme", "Shell"]
                         
  def has_http_url?
    (self.github_url =~ /^git@/).nil?
  end

  def main_language_available?
    unless LANGUAGES.include?(self.main_language)
      errors.add(:main_language, ' must be a programming language')
    end
  end

end
