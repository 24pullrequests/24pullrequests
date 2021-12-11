class ScoreCalculator
    attr_accessor :project
  
    def initialize(project)
      raise "Invalid type for ScoreCalculator, expected Project" unless project.class == Project
      @project = project
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
        # open_issues_created_since(6.months.ago) > 10 ? 5 : 0,
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
        # open_issues_last_6_months: open_issues_created_since(6.months.ago),
        master_commits_last_6_months: commits_since(6.months.ago)
      }
    end
  
    private
  
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
      project.has_issues?
    end
  
    def open_issues_created_since(date)
      project.issues.where(created_at: date.to_time.iso8601..Time.now.iso8601).count
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
  