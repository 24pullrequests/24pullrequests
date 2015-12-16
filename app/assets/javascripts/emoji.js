Emojify = {
  replace: function(selector) {
    $(selector).each(function(){
      Emojify._updateNode(this);
    });
  },

  _updateNode: function(node) {
    if (!Emojify._replace($(node).text()).match(/\[:\w+:\]/m))
      return;

    for (var i = 0; i < node.childNodes.length; i++) {
      var n = node.childNodes[i];

      if (n.nodeName == '#text') {
        var newNode = document.createElement('span');

        $.each(Emojify._splitEmo(Emojify._replace($(n).text())), function(i, e){
          newNode.appendChild(e);
        });

        $(n).replaceWith(newNode);
      }
    }
  },

  _createEmojiNode: function(text) {
    var node = document.createElement('div');
    node.innerHTML = emojione.shortnameToImage(text);
    return node.childNodes[0];
  },

  _splitEmo: function(str) {
    return $.map(str.split(/(\[:\w+:\])/gm), function(e){
      if (e.match(/^\[:\w+:\]$/))
        return Emojify._createEmojiNode(e.replace(/(\[|\])/, ''));

      return document.createTextNode(e);
    })
  },

  _replace: function(str) {
    str = Emojify._replace_at_start(str);
    str = Emojify._replace_at_end(str);
    str = Emojify._replace_whole_line(str);
    str = Emojify._replace_with_spaces_around(str);
    return str;
  },

  _replace_at_start: function(str) {
    var r = /^(:\w+:) /m

    if (!str.match(r))
      return str;

    str = str.replace(r, function(e){
      return '[' + $.trim(e) + '] ';
    });

    return Emojify._replace_at_start(str);
  },

  _replace_at_end: function(str) {
    var r = / (:\w+:)$/m

    if (!str.match(r))
      return str;

    str = str.replace(r, function(e){
      return ' [' + $.trim(e) + '] ';
    });

    return Emojify._replace_at_end(str);
  },

  _replace_whole_line: function(str) {
    var r = /^(:\w+:)$/m

    if (!str.match(r))
      return str;

    str = str.replace(r, function(e){
      return '[' + $.trim(e) + ']';
    });

    return Emojify._replace_whole_line(str);
  },

  _replace_with_spaces_around: function(str) {
    var r = / (:\w+:) /m

    if (!str.match(r))
      return str;

    str = str.replace(r, function(e){
      return ' [' + $.trim(e) + '] ';
    });

    return Emojify._replace_with_spaces_around(str);
  }
};
