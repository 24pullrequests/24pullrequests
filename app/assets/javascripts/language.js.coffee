@pull_requests.controller 'LanguageController', @LanguageCtrl = ($scope, $resource)->
  $scope.current_page = window.gon.page

  LanguageProjects = $resource('/language/:id/projects', { id: '@id', page: '@page' })

  $scope.load = (page) ->
    $scope.loadProjects(page)
    $scope.current_page = page
    $scope.project_count = window.gon.project_count
    $scope.total_pages = Math.floor($scope.project_count/window.gon.per_page)


  $scope.loadProjects = (page) ->
    LanguageProjects.query
     id: window.gon.language
     page: page
     , ((resource) ->
       $scope.projects =  resource
      )

  $scope.nextPage =->
    if ($scope.current_page < $scope.total_pages)
      $scope.current_page++
      $scope.load($scope.current_page)

  $scope.previousPage =->
    if ($scope.current_page > 1)
      $scope.current_page--
      $scope.load($scope.current_page)
