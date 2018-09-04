class ProjectSearch
  attr_reader :per_page

  def initialize(params = {})
    @page      = params.fetch(:page) { 1 }
    @per_page  = params.fetch(:per_page) { Project.default_per_page }
    @languages = Array(params[:languages])
    @labels    = Array(params[:labels])
    set_seed
  end

  def call
    by_languages
    by_labels
    results
  end

  def results
    projects
  end

  def more?
    (page * per_page) < Project.active.count
  end

  def page
    [@page.to_i, 1].max
  end

  def languages
    @languages.reject(&:blank?).map(&:downcase)
  end

  def labels
    @labels.reject(&:blank?)
  end

  private

  def projects
    @projects ||= Project.active.order(Arel.sql('random()')).page(page).per(per_page)
  end

  def by_languages
    @projects = projects.by_languages(languages) if languages.present?
  end

  def by_labels
    @projects = projects.by_labels(labels).select('projects.*, RANDOM()') if labels.present?
  end

  def set_seed
    Project.connection.execute 'select setseed(0.5)'
  end
end
