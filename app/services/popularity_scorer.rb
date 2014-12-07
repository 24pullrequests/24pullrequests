class PopularityScorer
  # The number of months of activity we will look at for scoring.
  MONTHS_OF_ACTIVITY = 3
  # For scoring, the number of commits we consider extremely busy.
  MAX_COMMITS      = 100
  # For scoring, the number of issues opened to consider extremely busy.
  MAX_ISSUES       = 20
  # Maximum number of points allowed per scoring facet.
  POINTS_PER_FACET = 10

  def initialize(nickname, token, project)
    @nickname = nickname
    @token    = token
    @project  = project
  end

  def score
    points = 0
    points += score_recent_commits
    points += score_recent_issues
    points
  end

  private

  def score_recent_commits
    commit_count = @project.commits(@nickname, @token, MONTHS_OF_ACTIVITY).size
    points_earned_for_facet(commit_count, MAX_COMMITS)
  end

  def score_recent_issues
    issue_count = @project.issues(@nickname, @token, MONTHS_OF_ACTIVITY).size
    points_earned_for_facet(issue_count, MAX_ISSUES)
  end

  def points_earned_for_facet(current, maximum)
    item_count = [current, maximum].min
    (item_count.to_f / maximum * POINTS_PER_FACET).round
  end
end
