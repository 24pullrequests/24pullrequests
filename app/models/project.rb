class Project < ApplicationRecord
  LANGUAGES = ['ABAP', 'ActionScript', 'Ada', 'Apex', 'AppleScript', 'Arc',
               'Arduino', 'ASP', 'Assembly', 'Augeas', 'AutoHotkey', 'Awk', 'Bluespec',
               'Boo', 'Bro', 'C', 'C#', 'C++', 'Ceylon', 'Chisel', 'CLIPS', 'Clojure',
               'COBOL', 'CoffeeScript', 'ColdFusion', 'Common Lisp', 'Coq',
               'CSS', 'Crystal', 'D', 'Dart', 'DCPU-16 ASM', 'Delphi', 'DOT', 'Dylan', 'eC', 'Ecl',
               'Eiffel', 'Elixir', 'Elm', 'Emacs Lisp', 'Erlang', 'F#',
               'Factor', 'Fancy', 'Fantom', 'Forth', 'FORTRAN', 'Go', 'Gosu',
               'Groovy', 'Haskell', 'Haxe', 'HTML', 'Io', 'Ioke', 'J', 'Java',
               'JavaScript', 'JSON', 'Julia', 'Kotlin', 'Lasso', 'LiveScript', 'Logos',
               'Logtalk', 'Lua', 'M', 'Markdown', 'Matlab', 'Max', 'Mirah',
               'Monkey', 'MoonScript', 'Nemerle', 'Nimrod', 'Nu',
               'Objective-C', 'Objective-J', 'OCaml', 'Omgrofl', 'ooc', 'Opa',
               'OpenEdge ABL', 'Parrot', 'Pascal', 'Perl', 'Perl 6', 'PHP', 'Pike',
               'PogoScript', 'PowerShell', 'Processing', 'Prolog', 'Puppet',
               'Pure Data', 'Python', 'R', 'Racket', 'Ragel in Ruby Host',
               'Rebol', 'Rouge', 'Ruby', 'Rust', 'Scala', 'Scheme', 'Scilab',
               'Self', 'Shell', 'Slash', 'Smalltalk', 'Squirrel',
               'Standard ML', 'SuperCollider', 'SVG', 'Swift', 'Tcl', 'TeX', 'Turing', 'TXL',
               'TypeScript', 'Vala', 'Verilog', 'VHDL', 'VimL', 'Visual Basic',
               'Volt', 'wisp', 'XC', 'XML', 'XProc', 'XQuery', 'XSLT', 'Xtend', 'YAML']

  has_many :project_labels
  has_many :labels, through: :project_labels

  belongs_to :submitted_by, class_name: 'User', foreign_key: :user_id, optional: true

  validates :description, :github_url, :name, :main_language, presence: true
  validates :github_url, format: { with: /\Ahttps?:\/\/github.com\/[\w-]+\/[\w\.-]+(\/)?\Z/i, message: 'Enter a valid GitHub URL.' }
  validates :github_url, uniqueness: { case_sensitive: false, message: 'Project has already been suggested.' }
  validates_length_of :description, within: 20..200
  validates_inclusion_of :main_language, in: LANGUAGES, message: 'must be a programming language'

  scope :not_owner, ->(user) { where('github_url NOT ILIKE ?', "%github.com/#{user}/%") }
  scope :by_language, ->(language) { where('lower(main_language) =?', language.downcase) }
  scope :by_languages, ->(languages) { where('lower(main_language) IN (?)', languages) }
  scope :by_labels, ->(labels) { joins(:labels).where('labels.name  IN (?)', labels).select('distinct(projects.id), projects.*') }
  scope :active, -> { where(inactive: [false, nil]) }
  scope :featured, -> { active.where(featured: true) }
  accepts_nested_attributes_for :labels, reject_if: proc { |attributes| attributes['id'].blank? }

  paginates_per 20

  def feature!(owner_id)
    update(featured: true, avatar_url: "https://avatars.githubusercontent.com/u/#{owner_id}?v=3")
  end

  def self.find_by_github_repo(repository)
    filter_by_repository(repository).first
  end

  def self.filter_by_repository(repository)
    Project.where('github_url like ?', "%#{repository}%")
  end

  def github_repository
    github_url.gsub(/^(((https|http|git)?:\/\/(www\.)?)|git@)github.com(:|\/)/i, '').gsub(/(\.git|\/)$/i, '')
  end

  def get_github_data(data_type, nickname, token, months_ago, options = {})
    date = (Time.zone.now - months_ago.months).utc.iso8601
    options.merge! since: date
    GithubClient.new(nickname, token).send(data_type.to_sym, github_repository, options)
  end

  def deactivate!
    update_attribute(:inactive, true)
  end

  def reactivate!
    update_attribute(:inactive, false)
  end

  def issues(nickname, token, months_ago = 6, options = {})
    get_github_data('issues', nickname, token, months_ago, options)
  end

  def commits(nickname, token, months_ago = 3, options = {})
    get_github_data('commits', nickname, token, months_ago, options)
  end

  def repository(nickname, token)
    GithubClient.new(nickname, token).repository(github_repository)
  end

  def score(token)
    ScoreCalculator.new(self, token).popularity_score
  end

  def update_score(token)
    update_columns contribulator: calculator(token).score, last_scored: Time.now
  end

  def calculator(token)
    @calculator ||= ScoreCalculator.new(self, token)
  end

  def repo_id
    github_id || github_repository
  end

  def github_client(token)
    GithubClient.new('', token).send(:client)
  end

  def has_issues?(token)
    repo = github_client(token).repo(repo_id)
    repo['has_issues']
  end

  def update_from_github(token)
    repo = github_client(token).repo(repo_id)
    attrs = {
      github_id:     repo[:id],
      name:          repo[:full_name],
      homepage:      format_url(repo[:homepage]),
      fork:          repo[:fork],
      main_language: repo[:language]
    }
    attrs[:description] = repo[:description][0..199] if repo[:description].present?
    update(attrs)
    update_score(token)
  rescue Octokit::NotFound, Octokit::RepositoryUnavailable, Octokit::InvalidRepository
    # bad repository
    update contribulator: 0, last_scored: Time.now
  rescue Octokit::Unauthorized
    # bad token
  end

  def format_url(url)
    return url if url.blank?
    url[/^https?:\/\//] ? url : "http://#{url}"
  end

  def url
    homepage.presence || github_url
  end

  def community_profile(nickname, token, options = {})
    get_github_data('community_profile', nickname, token, 1, options)
  end

  def contrib_url(nickname, token)
    repo = repository(nickname, token)
    options = repo.present? ? { owner: repo[:owner][:login], name: repo[:name] } : {}
    community_profile = community_profile(nickname, token, options)
    community_profile.files.contributing.try(:html_url) if community_profile.present?
  end
end
