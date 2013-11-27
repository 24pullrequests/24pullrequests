class Project < ActiveRecord::Base

  LANGUAGES = ["ActionScript", "Assembly", "C", "C#", "C++", "Clojure", "CoffeeScript",
               "ColdFusion", "CSS","Delphi", "Emacs Lisp", "Erlang", "Go", "Groovy", "Haskell", "HTML", "Java", "JavaScript",
               "Lua", "Objective-C", "OCaml","Pascal", "Perl", "PHP", "PowerShell", "Python", "Ruby",
               "Scala", "Scheme", "Shell", "VimL"]

  belongs_to :submitted_by, class_name: "User", foreign_key: :user_id

  validates_presence_of :description, :github_url, :name, :main_language
  validates_format_of :github_url, :with => /\Ahttps?:\/\/(www\.)?github.com\/[\w-]*\/[\w\.-]*(\/)?\Z/i, :message => 'Enter the full HTTP URL.'
  validates_uniqueness_of :github_url, :message => "Project has already been suggested."
  validates_length_of :description, :within => 20..200
  validates_inclusion_of :main_language, :in => LANGUAGES, :message => 'must be a programming language'

  scope :not_owner, lambda {|user| where("github_url" != "github.com/#{user}/") }
  scope :by_language, ->(language) { where("lower(main_language) =?", language.downcase) }

  def github_repository
    self.github_url.gsub(/^(((https|http|git)?:\/\/(www\.)?)|git@)github.com(:|\/)/i, '').gsub(/(\.git|\/)$/i, '')
  end
end
