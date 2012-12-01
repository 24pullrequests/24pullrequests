require 'github_url'

class Project < ActiveRecord::Base
  attr_accessible :description, :github_url, :name, :main_language

  validates_presence_of :description, :github_url, :name, :main_language
  validates_uniqueness_of :github_url, :message => "already been submitted"
  validates :github_url, :format => {
    :with => GithubUrl::REGEX,
    :message => "must be a github repository, e.g. 'user/repo', or 'https://github.com/user/repo'"
  }
  validates_length_of :description, :within => 20..200

  LANGUAGES = ["ActionScript", "Assembly", "C", "C#", "C++", "Clojure", "CoffeeScript",
               "ColdFusion", "CSS", "Emacs Lisp", "Erlang", "Haskell", "HTML", "Java", "JavaScript", 
               "Lua", "Objective-C", "Perl", "PHP", "PowerShell", "Python", "Ruby",
               "Scala", "Scheme", "Shell"]

  def github_url=(url)
    write_attribute(:github_url, GithubUrl.normalize(url))
  end

end
