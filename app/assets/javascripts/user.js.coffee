$ ->
  user_name = $("#coderwall-content").data('nickname')
  $('#coderwall-content').codersWall
    team: [user_name],
    badge_size: 72