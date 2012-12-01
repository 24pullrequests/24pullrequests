class Project < ActiveRecord::Base
  attr_accessible :description, :github_url, :name, :main_language

  validates_presence_of :description, :github_url, :name, :main_language
  validates_uniqueness_of :github_url, :message => "already been submitted"
  validates_length_of :description, :within => 20..200
  validate :github_url_is_fully_qualified

  LANGUAGES = ["ActionScript", "Assembly", "C", "C#", "C++", "Clojure", "CoffeeScript",
               "CSS", "Emacs Lisp", "Erlang", "Haskell", "HTML", "Java", "JavaScript", 
               "Lua", "Objective-C", "Perl", "PHP", "Python", "Ruby", "Scala", "Scheme"]

private
  def github_url_is_fully_qualified
    errors.add :github_url, "must be fully qualified (beginning with http://)" unless github_url =~ /\Ahttp\:\/\//
  end
end
