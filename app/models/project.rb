require 'github_url'

class Project < ActiveRecord::Base
  attr_accessible :description, :github_url, :name, :main_language

  validates_presence_of :description, :github_url, :name, :main_language
  validates_uniqueness_of :github_url, :message => "already been submitted"
  validates :github_url, :format => {
    :with => /\Ahttps:\/\/github\.com\/[a-zA-Z_-]\/[a-zA-Z_-]\Z/,
    :message => "must be a github repository, e.g. 'user/repo', or 'https://github.com/user/repo'"
  }
  validates_length_of :description, :within => 20..200

  before_save :normalize_github_url

  LANGUAGES = ["ActionScript", "Assembly", "C", "C#", "C++", "Clojure", "CoffeeScript",
               "ColdFusion", "CSS", "Emacs Lisp", "Erlang", "Haskell", "HTML", "Java", "JavaScript", 
               "Lua", "Objective-C", "Perl", "PHP", "PowerShell", "Python", "Ruby",
               "Scala", "Scheme", "Shell"]

  def normalize_github_url
    if github_url
      self.github_url = GithubUrl.normalize(github_url)
    end
  end

end
