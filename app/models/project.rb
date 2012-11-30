class Project < ActiveRecord::Base
  attr_accessible :description, :github_url, :name, :main_language

  validates_presence_of :description, :github_url, :name, :main_language
  validates_uniqueness_of :github_url, :message => "already been submitted"
  validates_length_of :description, :within => 20..200

  LANGUAGES = ["ActionScript", "Assembly", "C", "C#", "C++", "Clojure", "CoffeeScript", "Common Lisp", "CSS", "Diff", 
               "Emacs Lisp", "Erlang", "Haskell", "HTML", "Java", "JavaScript", 
               "Lua", "Objective-C", "Perl", "PHP", "Python", "Ruby", "Scala", 
               "Scheme", "XML"]
end
