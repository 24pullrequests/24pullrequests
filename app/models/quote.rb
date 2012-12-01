class Quote 
  attr_reader :name, :twitter_handle, :github_handle, :company, :comment

  def initialize(name, twitter_handle, github_handle, company, comment)
    @name = name
    @twitter_handle = twitter_handle
    @github_handle = github_handle
    @comment = company
    @comment = comment
  end
  
  def self.all
    [
      Quote.new('Peter Cooper', 'peterc', nil, nil, 'An interesting, programmer-related spin on the advent calendar!'),
      Quote.new('Bishop', '341-B', '341b', 'Weyland Wutani', "I may be synthetic but I'm not stupid.")
      ]
  end
  
  def self.random
    all[rand(all.size)-1]
  end
end
