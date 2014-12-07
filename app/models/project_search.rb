class ProjectSearch
  attr_accessor :languages

  def initialize(params = {})
    @page = params[:page]
    @languages = params[:languages] || []
    @labels = params[:labels] || []
    set_seed
    self
  end

  def find
    by_languages
    by_labels
    projects
  end

  private

  def projects
    @projects ||= Project.active.order('random()').page(page)
  end

  attr_reader :page

  def by_languages
    @projects = projects.by_languages(languages) if languages.present?
  end

  def by_labels
    @projects = projects.by_labels(labels).select('projects.*, RANDOM()') if labels.present?
  end

  def labels
    @labels.reject!(&:empty?)
    @labels
  end

  def languages
    @languages.reject!(&:empty?)
    @languages.map(&:downcase)
  end

  def set_seed
    Project.connection.execute 'select setseed(0.5)'
  end
end
