class NormalizeGithubUrls < ActiveRecord::Migration
  def up
    Project.all.each do |project|
      project.github_url = project.github_url
      project.save
    end
  end

  def down
  end
end
