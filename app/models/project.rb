class Project < ActiveRecord::Base
  attr_accessible :description, :github_url, :name, :main_language

  LANGUAGES = ["ActionScript", "Assembly", "C", "C#", "C++", "Clojure", "CoffeeScript",
               "ColdFusion", "CSS", "Emacs Lisp", "Erlang", "Groovy", "Haskell", "HTML", "Java", "JavaScript", 
               "Lua", "Objective-C", "OCaml", "Perl", "PHP", "PowerShell", "Python", "Ruby",
               "Scala", "Scheme", "Shell", "VimL"]

  validates_presence_of :description, :github_url, :name, :main_language
  validates_format_of :github_url, :with => /^https?:\/\/(www\.)?github.com\/[\w-]*\/[\w-]*(\/)?$/i, :message => 'Enter the full HTTP URL.'
  validates_uniqueness_of :github_url, :message => "Project has already been suggested."
  validates_length_of :description, :within => 20..200
  validates_inclusion_of :main_language, :in => LANGUAGES, :message => 'must be a programming language'

  def github_repository
    self.github_url.gsub(/^(((https|http|git)?:\/\/(www\.)?)|git@)github.com(:|\/)/i, '').gsub(/(\.git|\/)$/i, '')
  end
end
