# Test the cleanup script
fully_qualified = Project.create \
  description: 'this should have a fully qualified url',
  github_url: 'http://github.com/fully/qualified',
  name: 'qualified',
  main_language: 'Ruby'
relative = Project.new \
  description: 'this should have a relative github url',
  github_url: 'github.com/dontwork/relative_path',
  name: 'relative_relative',
  main_language: 'Ruby'
relative.save(validate: false)
