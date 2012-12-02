module ProjectsHelper
  def format_url(path)
    return "https://#{path}" if path =~ /^github.com\//
    path
  end
end