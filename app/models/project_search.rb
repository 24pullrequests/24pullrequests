class ProjectSearch

  attr_accessor :languages

  def initialize params={}
    @page = params[:page]
    @languages = params[:languages] || []
    @labels = params[:labels] || []
    self
  end

  def find
    by_languages
    by_labels
    projects
  end

  def projects
    @projects ||= Project.active.order(:name).page(page)
  end

  def page
    @page
  end

  private
  def by_languages
    @projects = projects.by_languages(languages) if languages.present?
  end

  def by_labels
    @projects = projects.by_labels(labels) if labels.present?
  end

  def labels
    @labels.reject! { |l| l.empty? }
    @labels.join(",")
  end

  def languages
    @languages.reject! { |l| l.empty? }
    @languages.map(&:downcase)
  end
end
