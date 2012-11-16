class Project < ActiveRecord::Base
  attr_accessible :description, :github_url, :name, :main_language

  validates_presence_of :description, :github_url, :name, :main_language

  LANGUAGES = ["ActionScript", "C", "C#", "C++", "Common Lisp", "CSS", "Diff", 
               "Emacs Lisp", "Erlang", "Haskell", "HTML", "Java", "JavaScript", 
               "Lua", "Objective-C", "Perl", "PHP", "Python", "Ruby", "Scala", 
               "Scheme", "TeX", "XML"]
end
