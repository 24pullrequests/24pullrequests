module ProjectHelper

  def class_for_inactive project
    project.inactive ? "inactive" : ""
  end

  def inactive? project
    content_tag :span, "inactive", class: "info"
  end

  def edit_path_for_project project, admin
    return edit_admin_project_path(project) if admin
    edit_project_path(project)
  end

  def path_for_project project, admin
    return admin_project_path(project) if admin
    project_path(project)
  end
end
