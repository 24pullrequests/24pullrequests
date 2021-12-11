class ScoreCalculator
    # The number of months of activity we will look at for scoring.
    MONTHS_OF_ACTIVITY = 3
    # For scoring, the number of commits we consider extremely busy.
    MAX_COMMITS      = 100
    # For scoring, the number of issues opened to consider extremely busy.
    MAX_ISSUES       = 20
    # Maximum number of points allowed per scoring facet.
    POINTS_PER_FACET = 10

    attr_accessor :project
    attr_accessor :token
  
    def initialize(project, token)
      raise "Invalid type for ScoreCalculator, expected Project" unless project.class == Project
      @project = project
      @token = token
    end
    
    def popularity_score
      points = 0
      points += recent_activity
      points += score_recent_issues
      points
    end

    def score
      [
        fork? ? 0 : 1,
        description_present? ? 1 : 0,
        homepage_present? ? 1 : 0,
        readme_present? ? 5 : 0,
        contributing_present? ? 5 : 0,
        license_present? ? 5 : 0,
        changelog_present? ? 1 : 0,
        tests_present? ? 5 : 0,
        code_of_conduct_present? ? 5 : 0,
        open_issues_created_since(6) > 10 ? 5 : 0,
        commits_since(6.months.ago) > 10 ? 5 : 0,
        issues_enabled? ? 5 : 0
      ].sum
    end
  
    def summary
      {
        fork: fork?,
        description_present: description_present?,
        homepage_present: homepage_present?,
        readme_present: readme_present?,
        contributing_present: contributing_present?,
        license_present: license_present?,
        changelog_present: changelog_present?,
        tests_present: tests_present?,
        code_of_conduct_present: code_of_conduct_present?,
        issues_enabled: issues_enabled?,
        open_issues_last_6_months: open_issues_created_since(6),
        master_commits_last_6_months: commits_since(6.months.ago)
      }
    end
  
    private

    def recent_activity
      updated_at = @project.repository(nil, @token).updated_at
      if updated_at
        updated_at > Time.zone.today - MONTHS_OF_ACTIVITY ? 5 : 0
      else
        0
      end
    end
  
    def score_recent_issues
      issue_count = @project.issues(nil, @token, MONTHS_OF_ACTIVITY, per_page: MAX_ISSUES).size
      points_earned_for_facet(issue_count, MAX_ISSUES)
    end
  
    def points_earned_for_facet(current, maximum)
      item_count = [current, maximum].min
      (item_count.to_f / maximum * POINTS_PER_FACET).round
    end  
  
    def fork?
      project.fork?
    end
  
    def description_present?
      project.description.present?
    end
  
    def homepage_present?
      project.homepage.present?
    end
  
    def readme_present?
      file_exists?('readme')
    end
  
    def contributing_present?
      file_exists?('contributing')
    end
  
    def license_present?
      file_exists?('license')
    end
  
    def code_of_conduct_present?
      file_exists?('conduct')
    end
  
    def changelog_present?
      file_exists?('change') || has_releases?
    end
  
    def tests_present?
      folder_exists?('test') || folder_exists?('spec') || folder_exists?('tests')
    end
  
    def has_releases?
      github_client.releases(project.repo_id).count > 1
    end
  
    def issues_enabled?
      project.has_issues?(token)
    end
  
    def open_issues_created_since(months)
      date = (Time.zone.now - months.months).utc.iso8601
      options = { since: date, per_page: 20 }
      github_client.issues(project.repo_id, options).size
    end
  
    def commits_since(date)
      github_client.commits_since(project.repo_id, date.to_time.iso8601).count
    end
  
    def github_client
      project.github_client
    end
  
    def ls
      @ls ||= github_client.contents(project.repo_id)
    end
  
    def files
      ls.select { |f| f[:type] == 'file' }.map { |f| f[:path] }
    end
  
    def folders
      ls.select { |f| f[:type] == 'dir' }.map { |f| f[:path] }
    end
  
    def file_exists?(name)
      files.find { |f| f.match(/#{name}/i) }.present?
    end
  
    def folder_exists?(name)
      folders.find { |f| f.match(/#{name}/i) }.present?
    end
  end
  