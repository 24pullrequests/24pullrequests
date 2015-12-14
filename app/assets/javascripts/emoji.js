Emojify = {
  replace: function(selector) {
    $(selector).each(function(){
      Emojify._updateNode(this);
    });
  },

  _updateNode: function(node) {
    if (!Emojify._replace(node.textContent).match(/\[:\w+:\]/m))
      return;

    for (var i = 0; i < node.childNodes.length; i++) {
      var n = node.childNodes[i];

      if (n.nodeName == '#text') {
        var newNode = document.createElement('span');

        Emojify._splitEmo(Emojify._replace(n.textContent)).forEach(function(e){
          newNode.appendChild(e);
        });

        n.parentNode.replaceChild(newNode, n);
      }
    }
  },

  _createEmojiNode: function(text) {
    var node = document.createElement('div');
    node.innerHTML = emojione.shortnameToImage(text);
    return node.childNodes[0];
  },

  _splitEmo: function(str) {
    return str.split(/(\[:\w+:\])/gm).map(function(e){
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
      return '[' + e.trim() + '] ';
    });

    return Emojify._replace_at_start(str);
  },

  _replace_at_end: function(str) {
    var r = / (:\w+:)$/m

    if (!str.match(r))
      return str;

    str = str.replace(r, function(e){
      return ' [' + e.trim() + '] ';
    });

    return Emojify._replace_at_end(str);
  },

  _replace_whole_line: function(str) {
    var r = /^(:\w+:)$/m

    if (!str.match(r))
      return str;

    str = str.replace(r, function(e){
      return '[' + e.trim() + ']';
    });

    return Emojify._replace_whole_line(str);
  },

  _replace_with_spaces_around: function(str) {
    var r = / (:\w+:) /m

    if (!str.match(r))
      return str;

    str = str.replace(r, function(e){
      return ' [' + e.trim() + '] ';
    });

    return Emojify._replace_with_spaces_around(str);
  }
};
