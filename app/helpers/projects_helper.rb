module ProjectsHelper
  def format_url(path)
    path = path =~ /^github.com\// ? "https://#{path}" : path
  end
end